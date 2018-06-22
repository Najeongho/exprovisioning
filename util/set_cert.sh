## 인증키 저장 디렉토리 생성 및 진입
mkdir /root/certs
cd /root/certs
 
## openssl.conf 설정 파일 생성 (상세한 파일 설정 내용은 (3)번 내용 참조)
touch /root/certs/openssl.conf
 
 
## Private Key 생성(.key)
openssl genrsa -out cert.key 4096
 
 
## Certificate Pem 생성(.pem)
openssl req -x509 -new -nodes -key cert.key -days 3650 -out cert.pem
 
 
## Certificate Request 생성(.csr)
openssl req -new -key cert.key -out cert.csr
 
 
## openssl.conf 설정 반영한 Certificate Public Key 생성(.crt)
openssl x509 -req -extensions server -extfile openssl.conf -in cert.csr -CA cert.pem -CAkey cert.key -CAcreateserial -out cert.crt -days 3650
 
 
## Certificate용 Binary 인증키 생성(.pfx)
openssl pkcs12 -export -inkey cert.key -in cert.crt -out cert.pfx
