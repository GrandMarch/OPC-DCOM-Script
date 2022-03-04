@echo off
echo ������opc server��ִ���ļ�·��
set /p opcserver=opc server:
echo ������opc server CLSID
set /p opcserverCLSID=Opc Server CLSID:
echo ������opc enum��ִ���ļ�·��(64λϵͳ��C:\Windows\SysWOW64\opcenum.exe)
set /p opcenum=opcenum:
set CCDIR=%~dp0 
SET logfile="%CCDIR%DCOMConfig.log" 
echo %~d0 > %logfile% echo �������� >>%logfile% 

echo ��ӷ���ǽ���� >>%logfile% 
netsh advfirewall firewall add rule name="tcp135" protocol=TCP dir=in localport=135 action=allow >>%logfile% 
netsh advfirewall firewall add rule name="udp135" protocol=UDP dir=in localport=135 action=allow >>%logfile% 
::ע��·��
netsh advfirewall firewall add rule name="opcserver" dir=in program=%opcserver% remoteip=any action=allow >>%logfile% 
netsh advfirewall firewall add rule name="opcenum"   dir=in program=%opcenum%   remoteip=any action=allow >>%logfile% 

echo DCOM����Ȩ��-�༭Ĭ��ֵ >>%logfile% 
::����COM��ȫ-����Ȩ��-�༭Ĭ��ֵ��Ȩ���޸�Ϊ����Զ�̷��ʺͱ��ط���
::da= Modify or list the default access permission list
dcomperm -da set "Distribute COM Users" permit level:r,l >>%logfile% 
dcomperm -da set "Anonymous Logon" permit level:r,l >>%logfile% 
dcomperm -da set "Everyone" permit level:r,l >>%logfile% 
dcomperm -da set "Interactive" permit level:r,l >>%logfile% 
dcomperm -da set "System" permit level:r,l >>%logfile% 
dcomperm -da set "SELF" permit level:r,l >>%logfile% 
dcomperm -da set "Administrators" permit level:r,l >>%logfile% 

echo DCOM����Ȩ��-�༭���� >>%logfile% 
::����COM��ȫ-����Ȩ��-�༭���ƣ�Ȩ���޸�Ϊ����Զ�̷��ʺͱ��ط���
::ma= Modify or list the machine access permission list
dcomperm -ma set "Distribute COM Users" permit level:r,l >>%logfile% 
dcomperm -ma set "Anonymous Logon" permit level:r,l >>%logfile% 
dcomperm -ma set "Everyone" permit level:r,l >>%logfile% 
dcomperm -ma set "Interactive" permit level:r,l >>%logfile% 
dcomperm -ma set "System" permit level:r,l >>%logfile%
dcomperm -ma set "Administrators" permit level:r,l >>%logfile% 

echo DCOM�����ͼ���Ȩ��-�༭Ĭ��ֵ >>%logfile% 
::����COM��ȫ-�����ͼ���Ȩ��-�༭Ĭ��ֵ��Ȩ���޸�Ϊ����Զ�̷��ʺͱ��ط���
::dl= Modify or list the default launch permission list
dcomperm -dl set "Distribute COM Users" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Anonymous Logon" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Everyone" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Interactive" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "System" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Administrators" permit level:rl,ll,la,ra >>%logfile% 

echo DCOM�����ͼ���Ȩ������-�༭��ֵ >>%logfile% 
::����COM��ȫ-�����ͼ���Ȩ��-�༭���ƣ�Ȩ���޸�Ϊ����Զ�̷��ʺͱ��ط���
::ml= Modify or list the machine launch permission list
dcomperm -ml set "Distribute COM Users" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Anonymous Logon" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Everyone" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Interactive" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "System" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Administrators" permit level:rl,ll,la,ra >>%logfile% 

::opcenum����
echo opcenum�����������Ȩ�޵����� >>%logfile% 
::dcomperm -runas {13486D44-4821-11D2-A494-3CB306C10000} "Interactive User" >>%logfile%
dcomperm -al {13486D44-4821-11D2-A494-3CB306C10000} Default >>%logfile%
dcomperm -aa {13486D44-4821-11D2-A494-3CB306C10000} Default >>%logfile%

::opc server����
::echo opc server�����������Ȩ�޵����� >>%logfile% 
::dcomperm -runas %opcserverCLSID% "Interactive User" >>%logfile%
dcomperm -al %opcserverCLSID%  Default >>%logfile%
dcomperm -aa %opcserverCLSID% Default >>%logfile%

::ͨ��ע��������������
echo �������� DCOM���ע����ļ�  >>%logfile%
echo Windows Registry Editor Version 5.00 > DCOM.reg
echo. >> DCOM.reg
echo ;����[�������]-[�����]-[�ҵĵ���]-[��������]Ĭ�������֤����Ϊ[����]-Ĭ��ģ�⼶��Ϊ[��ʶ] >> DCOM.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole] >> DCOM.reg
echo "EnableDCOM"="Y" >> DCOM.reg
echo "LegacyAuthenticationLevel"=dword:00000002 >> DCOM.reg
echo "LegacyImpersonationLevel"=dword:00000002 >> DCOM.reg
echo. >> DCOM.reg

echo ;����[�������]-[�����]-[�ҵĵ���]-[DCOM����]-[opcEnum]-�����֤����Ϊ[����]-�ս��Ϊ[�������ӵ�TCP/IP]-����Ϊ[ʹ��Ĭ���ս��] >> DCOM.reg
echo [HKEY_CLASSES_ROOT\AppID\{13486D44-4821-11D2-A494-3CB306C10000}] >> DCOM.reg
echo @="OpcEnum" >> DCOM.reg
echo "AuthenticationLevel"=dword:00000002 >> DCOM.reg
echo "EndPoints"=hex(7):6e,00,63,00,61,00,63,00,6e,00,5f,00,69,00,70,00,5f,00,74,00,\ >> DCOM.reg
echo   63,00,70,00,2c,00,30,00,2c,00,00,00,00,00 >> DCOM.reg
echo. >> DCOM.reg

echo ;����[���ذ�ȫ�������]-[���ز���]-[��ȫѡ��]-[�������]�����˻��Ĺ���ȫģ��-[����-�Ա����û����������֤�����ı��䱾�����] >> DCOM.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Lsa] >> DCOM.reg
echo "forceguest"=dword:00000000 >> DCOM.reg
echo. >> DCOM.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa] >> DCOM.reg
echo "forceguest"=dword:00000000 >> DCOM.reg

echo ;����[���ذ�ȫ�������]-[���ز���]-[��ȫѡ��]-[���簲ȫ:LAN�����������֤����] >> DCOM.reg
echo ;"LmCompatibilityLevel"=dword:00000001 >> DCOM.reg
echo ���� DCOM���ע���  >>%logfile%

regedit /s DCOM.reg 
del DCOM.reg 
echo �������,��������˳�... >>%logfile% 
pause>>nul