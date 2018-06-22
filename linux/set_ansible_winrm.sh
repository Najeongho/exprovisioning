## 변수 목록
win_host="win-host"
test_path="/root/ansible-test"
test_file="winrm-conn-test.py"
playbook_name="winrm-conn-test.yaml"
crt_file_path="/root/certs/cert.crt"
key_file_path="/root/certs/cert.key"
ansible_path="/etc/ansible"
 
 
## Python 설치
apt install -y python
  
 
## pip 설치
apt install -y python-pip
 
 
## Ansible 설치
apt install -y ansible
  
 
## pip를 이용한 pywinrm 설치
pip install pywinrm
  
 
## 접속 테스트 확인 파일 생성 및 실행
mkdir $test_path
 
cat > $test_path/$test_file <<EOF
from winrm.protocol import Protocol
p = Protocol(
endpoint='https://$win_host:5986/wsman',
transport='certificate',
username='Administrator',
cert_pem='$crt_file_path',
cert_key_pem='$key_file_path',
server_cert_validation='ignore'
)
 
shell_id = p.open_shell()
command_id = p.run_command(shell_id,'ipconfig')
 
std_out, std_err, status_code = p.get_command_output(shell_id, command_id)
print std_out
 
p.cleanup_command(shell_id, command_id)
p.close_shell(shell_id)
EOF
  
 
# 대상 윈도우 서버의 ipconfig 정보가 정상적으로 출력되면 접속 성공
python $test_path/$test_file
  
 
# ansible hosts 파일에 대상 윈도우 서버 정보 추가
echo -e "[windows]\\n$win_host" >> $ansible_path/hosts
 
 
## Group Extra Variable 추가
mkdir $ansible_path/group_vars
 
cat > $ansible_path/group_vars/windows.yaml <<EOF
ansible_port: 5986
ansible_connection: winrm
ansible_winrm_transport: certificate
ansible_winrm_cert_pem: $crt_file_path
ansible_winrm_cert_key_pem: $key_file_path
ansible_winrm_server_cert_validation: ignore
EOF
  
 
## Ansible을 통한 Windows 서버 접근 확인
cat > $test_path/$playbook_name <<EOF
- name: windows server connect test
  hosts: windows
  tasks:
    - name: Run command ipconfig
      win_command: ipconfig
      register: reg
    - debug: var=reg
EOF
 
ansible-playbook $test_path/$playbook_name
