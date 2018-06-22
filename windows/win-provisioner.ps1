## SSL 통신 허용
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
## 에러 발생시 추가 액션 "중지"
$ErrorActionPreference = "Stop"
 
## 스크립트 로컬에서 별도의 실행 정책 없이 실행할수 있도록 허용
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force
 
## Chocolatey 패키지 매니저 설치
iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
choco feature enable -n allowEmptyChecksums
 
 
## WinRM 기능 활성
winrm quickconfig -force
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
 
 
## Ansible 서버 및 AWX 서버 IP 혹은 도메인명 명시
winrm set winrm/config/client '@{TrustedHosts = "<Ansible 서버1>,<Ansible 서버2>"}'
 
 
## Python 및 PIP 환경 변수 추가
[Environment]::SetEnvironmentVariable(“Path”, "$env:Path;C:\Python27;C:\Python27\Scripts",”User”)
[Environment]::SetEnvironmentVariable(“Path”, "$env:Path;C:\Python27;C:\Python27\Scripts",”Machine”)
 
 
## C:\에 ansible 폴더 생성 (파일 다운로드용)
New-Item -ItemType directory -Path C:\ansible
 
 
## 환경변수 즉시 반영용 함수 명시 및 실행
function Update-Environment {  
    $locations = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
                 'HKCU:\Environment'
 
 
    $locations | ForEach-Object {  
        $k = Get-Item $_
        $k.GetValueNames() | ForEach-Object {
            $name  = $_
            $value = $k.GetValue($_)
            Set-Item -Path Env:\$name -Value $value
        }
    }
}
 
Update-Environment
 
 
## Ansible Windows용 모듈 다운로드 및 적용
$url = "https://seo01.objectstorage.softlayer.net/v1/<Softlayer Object Storage 경로>/ansible/ConfigureRemotingForAnsible.ps1"
$outpath = "c:\ansible\ConfigureRemotingForAnsible.ps1"
 
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
 
powershell -File $outpath -CertValidityDays 1825
 
 
## Cert 저장 폴더 생성
$folderpath = "C:\certs"
New-Item -ItemType directory -Path $folderpath
   
  
## Certificate 인증키를 Object Storage에서 Download
$filename = "cert.pfx"
$url = "https://seo01.objectstorage.softlayer.net/v1/<Softlayer Object Storage 경로>/certs/$filename"
$outpath = "$folderpath\$filename"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
   
  
## certificate 인증키를 시스템에 등록
$username = "Administrator"
$password = ConvertTo-SecureString -String "<Certifaicate 인증키 Password>" -AsPlainText -Force
  
Import-pfxCertificate -FilePath $outpath -CertStoreLocation Cert:\LocalMachine\My -Password $password
Import-pfxCertificate -FilePath $outpath -CertStoreLocation Cert:\LocalMachine\Root -Password $password
Import-pfxCertificate -FilePath $outpath -CertStoreLocation Cert:\LocalMachine\TrustedPeople -Password $password
  
 
 
## 추가된 Listener 삭제 (불필요 Listener)
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
 
  
## 윈도우 방화벽 5986 포트 허용
netsh advfirewall firewall add rule name=”Windows Remote Management(HTTPS-In)” dir=in action=allow protocol=TCP localport=5986 remoteip=any
  
  
## WinRM에서 Certificate 접근 허용
winrm set winrm/config/Service/Auth '@{Certificate = "true"}'
  
  
## thumbprint 추출
$thumbprint = (Get-ChildItem -Path cert:\LocalMachine\My | Where-Object {$_.Subject -Match ".pubg.com"}).Thumbprint
  
 
## Python Download
$url = "https://seo01.objectstorage.softlayer.net/v1/<Softlayer Object Storage 경로>/ansible/python-2.7.15.amd64.msi"
$outpath = "c:\ansible\python-2.7.15.amd64.msi"
 
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
 
 
## Python install
c:\ansible\python-2.7.15.amd64.msi /quiet
 
 
## pip Download
$url = "https://seo01.objectstorage.softlayer.net/v1/<Softlayer Object Storage 경로>/ansible/get-pip.py"
$outpath = "c:\ansible\get-pip.py"
 
 
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
 
## Python이 설치 완료되기 전까지 20초 대기
Start-Sleep -s 20
 
 
## pip Install
python c:\ansible\get-pip.py
python -m pip install --upgrade pip
 
 
## pip requests install
pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org requests
 
 
## Download softlayer get password script
$url = "https://seo01.objectstorage.softlayer.net/v1/<Softlayer Object Storage 경로>/ansible/get_pw.py"
$outpath = "c:\ansible\get_pw.py"
 
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $outpath)
 
 
## Run softlayer get password script
python c:\ansible\get_pw.py
 
$os_password = Get-Content -Path C:\ansible\pw.txt
$adm_password = ConvertTo-SecureString -String $os_password -AsPlainText -Force
 
 
## certificate 인증키 만으로 접근할 수 있도록 시스템에 인증키 등록
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $adm_password
New-Item -Path WSMan:\localhost\ClientCertificate -URI * -Subject * -Issuer $thumbprint -Credential $credential -confirm:$false -Force
  
  
## WinRM Listener 활성화
New-Item WSMan:\localhost\Listener -Address * -Transport HTTPS -CertificateThumbPrint $thumbprint -Force
