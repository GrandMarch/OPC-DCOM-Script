@echo off
echo 请输入opc server可执行文件路径
set /p opcserver=opc server:
echo 请输入opc server CLSID
set /p opcserverCLSID=Opc Server CLSID:
echo 请输入opc enum可执行文件路径(64位系统在C:\Windows\SysWOW64\opcenum.exe)
set /p opcenum=opcenum:
set CCDIR=%~dp0 
SET logfile="%CCDIR%DCOMConfig.log" 
echo %~d0 > %logfile% echo 配置启动 >>%logfile% 

echo 添加防火墙规则 >>%logfile% 
netsh advfirewall firewall add rule name="tcp135" protocol=TCP dir=in localport=135 action=allow >>%logfile% 
netsh advfirewall firewall add rule name="udp135" protocol=UDP dir=in localport=135 action=allow >>%logfile% 
::注意路径
netsh advfirewall firewall add rule name="opcserver" dir=in program=%opcserver% remoteip=any action=allow >>%logfile% 
netsh advfirewall firewall add rule name="opcenum"   dir=in program=%opcenum%   remoteip=any action=allow >>%logfile% 

echo DCOM访问权限-编辑默认值 >>%logfile% 
::设置COM安全-访问权限-编辑默认值，权限修改为允许远程访问和本地访问
::da= Modify or list the default access permission list
dcomperm -da set "Distribute COM Users" permit level:r,l >>%logfile% 
dcomperm -da set "Anonymous Logon" permit level:r,l >>%logfile% 
dcomperm -da set "Everyone" permit level:r,l >>%logfile% 
dcomperm -da set "Interactive" permit level:r,l >>%logfile% 
dcomperm -da set "System" permit level:r,l >>%logfile% 
dcomperm -da set "SELF" permit level:r,l >>%logfile% 
dcomperm -da set "Administrators" permit level:r,l >>%logfile% 

echo DCOM访问权限-编辑限制 >>%logfile% 
::设置COM安全-访问权限-编辑限制，权限修改为允许远程访问和本地访问
::ma= Modify or list the machine access permission list
dcomperm -ma set "Distribute COM Users" permit level:r,l >>%logfile% 
dcomperm -ma set "Anonymous Logon" permit level:r,l >>%logfile% 
dcomperm -ma set "Everyone" permit level:r,l >>%logfile% 
dcomperm -ma set "Interactive" permit level:r,l >>%logfile% 
dcomperm -ma set "System" permit level:r,l >>%logfile%
dcomperm -ma set "Administrators" permit level:r,l >>%logfile% 

echo DCOM启动和激活权限-编辑默认值 >>%logfile% 
::设置COM安全-启动和激活权限-编辑默认值，权限修改为允许远程访问和本地访问
::dl= Modify or list the default launch permission list
dcomperm -dl set "Distribute COM Users" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Anonymous Logon" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Everyone" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Interactive" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "System" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -dl set "Administrators" permit level:rl,ll,la,ra >>%logfile% 

echo DCOM启动和激活权限限制-编辑限值 >>%logfile% 
::设置COM安全-启动和激活权限-编辑限制，权限修改为允许远程访问和本地访问
::ml= Modify or list the machine launch permission list
dcomperm -ml set "Distribute COM Users" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Anonymous Logon" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Everyone" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Interactive" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "System" permit level:rl,ll,la,ra >>%logfile% 
dcomperm -ml set "Administrators" permit level:rl,ll,la,ra >>%logfile% 

::opcenum设置
echo opcenum启动激活访问权限等设置 >>%logfile% 
::dcomperm -runas {13486D44-4821-11D2-A494-3CB306C10000} "Interactive User" >>%logfile%
dcomperm -al {13486D44-4821-11D2-A494-3CB306C10000} Default >>%logfile%
dcomperm -aa {13486D44-4821-11D2-A494-3CB306C10000} Default >>%logfile%

::opc server设置
::echo opc server启动激活访问权限等设置 >>%logfile% 
::dcomperm -runas %opcserverCLSID% "Interactive User" >>%logfile%
dcomperm -al %opcserverCLSID%  Default >>%logfile%
dcomperm -aa %opcserverCLSID% Default >>%logfile%

::通过注册表更改其他参数
echo 生成其他 DCOM相关注册表文件  >>%logfile%
echo Windows Registry Editor Version 5.00 > DCOM.reg
echo. >> DCOM.reg
echo ;设置[组件服务]-[计算机]-[我的电脑]-[连接属性]默认身份验证级别为[连接]-默认模拟级别为[标识] >> DCOM.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Ole] >> DCOM.reg
echo "EnableDCOM"="Y" >> DCOM.reg
echo "LegacyAuthenticationLevel"=dword:00000002 >> DCOM.reg
echo "LegacyImpersonationLevel"=dword:00000002 >> DCOM.reg
echo. >> DCOM.reg

echo ;设置[组件服务]-[计算机]-[我的电脑]-[DCOM配置]-[opcEnum]-身份验证级别为[连接]-终结点为[面向连接的TCP/IP]-属性为[使用默认终结点] >> DCOM.reg
echo [HKEY_CLASSES_ROOT\AppID\{13486D44-4821-11D2-A494-3CB306C10000}] >> DCOM.reg
echo @="OpcEnum" >> DCOM.reg
echo "AuthenticationLevel"=dword:00000002 >> DCOM.reg
echo "EndPoints"=hex(7):6e,00,63,00,61,00,63,00,6e,00,5f,00,69,00,70,00,5f,00,74,00,\ >> DCOM.reg
echo   63,00,70,00,2c,00,30,00,2c,00,00,00,00,00 >> DCOM.reg
echo. >> DCOM.reg

echo ;设置[本地安全和组策略]-[本地策略]-[安全选项]-[网络访问]本地账户的共享安全模型-[经典-对本地用户进行身份验证，不改变其本来身份] >> DCOM.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Lsa] >> DCOM.reg
echo "forceguest"=dword:00000000 >> DCOM.reg
echo. >> DCOM.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa] >> DCOM.reg
echo "forceguest"=dword:00000000 >> DCOM.reg

echo ;设置[本地安全和组策略]-[本地策略]-[安全选项]-[网络安全:LAN管理器身份验证级别] >> DCOM.reg
echo ;"LmCompatibilityLevel"=dword:00000001 >> DCOM.reg
echo 导入 DCOM相关注册表  >>%logfile%

regedit /s DCOM.reg 
del DCOM.reg 
echo 配置完成,按任意键退出... >>%logfile% 
pause>>nul