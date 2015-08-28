# Условия дополнительные:
# 1.внести в /etc/ld.so.conf 
#        /home/inferno/git/afudf/build/linux-i386
#        /home/inferno/git/afudf/build/linux-x86_64
#        выполнитьldconfig    
#

%define name    af-udf
%define version %(cat version | grep version | cut -c9-)
%define release %(cat version | grep build | cut -c7-).%(cat version | grep release | cut -c9-)

%define projectdir ~/git/afudf

%define __find_requires %{nil}
# libc.so.6 libc.so.6(GLIBC_2.0) libc.so.6(GLIBC_2.1)

Name:       %{name}
Version:    %{version}
Release:    %{release}
Summary:    Library AF-UDF for Firebird
Vendor:     OAO Farmacy,Russia,Tuymen region
Packager:   Arteev Alexei <arteev@pharm-tmn.ru>



URL:            http://www.pharm-tmn.ru/afudf

Group:          Databases  
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-buildroot
License:        GPL

Requires:       libc.so.6



%description
Library AF-UDF for Firebird 1.X or higher version.
Components: xml,dbf,zip,text file function,filesystem function and etc.
Prior to the beginning of installation firebird service should be started.
Please restart Firebird after installation.
Register udf functions for a database by means of scripts in a %{_libdir}/af-udf/sql.

%description -l ru
Библиотека AF-UDF для сервера Firebird 1.X и выше. 
Компоненты: xml,dbf,zip,функции с текстовыми файлами,функции файловой системы and т.д.
Пожалуйста после установки перезапустите службу firebird вручную.
Если необходимо, зарегистрируйте udf функции в базе данных с помощью скриптов в папке %{_libdir}/af-udf/sql.

%build 
#oldpwd=`pwd`
#cd /mnt/win_d/work/farm/AFUDF-FPC/
#./make.all.sh
#cd $oldpwd

%files
/opt/firebird/UDF/afmmngr.so
/opt/firebird/UDF/afcommon.so
/opt/firebird/UDF/afucrypt.so
/opt/firebird/UDF/afudbf.so
/opt/firebird/UDF/afufile.so
/opt/firebird/UDF/afumisc.so
/opt/firebird/UDF/afutextfile.so
/opt/firebird/UDF/afuxml.so
/opt/firebird/UDF/afuzip.so

/usr/doc/af-udf/*
%{_libdir}/af-udf/sql/*.sql


%install
[ -n "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf $RPM_BUILD_ROOT
fbdirbase=/opt/firebird
fbdirudf=$fbdirbase/UDF

install -d $RPM_BUILD_ROOT$fbdirudf
install -d $RPM_BUILD_ROOT/usr/doc/af-udf/
install -d $RPM_BUILD_ROOT/%{_libdir}/af-udf/sql/

cp -f   %{projectdir}/build/linux-%{_target_cpu}/afmmngr.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afcommon.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afucrypt.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afudbf.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afufile.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afumisc.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afutextfile.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afuxml.so $RPM_BUILD_ROOT$fbdirudf
cp -f   %{projectdir}/build/linux-%{_target_cpu}/afuzip.so $RPM_BUILD_ROOT$fbdirudf




cp -f   %{projectdir}/sql/reg/*.sql $RPM_BUILD_ROOT/%{_libdir}/af-udf/sql/
cp -f   %{projectdir}/sql/reg/cngmodname/*.sql $RPM_BUILD_ROOT/%{_libdir}/af-udf/sql/
cp -f   %{projectdir}/help/bugs $RPM_BUILD_ROOT/usr/doc/af-udf/
cp -f   %{projectdir}/changelog.txt $RPM_BUILD_ROOT/usr/doc/af-udf/
cp -f   %{projectdir}/help/install.txt $RPM_BUILD_ROOT/usr/doc/af-udf/
cp -f   %{projectdir}/help/man-af-udf.pdf $RPM_BUILD_ROOT/usr/doc/af-udf/

echo "Please restart Firebird now"


%clean
[ -n "$RPM_BUILD_ROOT" -a "$RPM_BUILD_ROOT" != / ] && rm -rf $RPM_BUILD_ROOT

%post
fbdirbase=/opt/firebird
fbdirudf=$fbdirbase/UDF
chown firebird:firebird $RPM_BUILD_ROOT$fbdirudf/*.so
echo "$RPM_BUILD_ROOT$fbdirudf" > /etc/ld.so.conf.d/firebird-af-udf.conf

#fb=`rpm -ql firebird | egrep UDF$`
#if [[ -n $fb ]]; then 
# make links
#  echo "make symlinks for $fb"
#    rm -f $fb/afcommon.so
#    rm -f $fb/afmmngr.so
#    rm -f  $fb/afucrypt.so
#    rm -f  $fb/afudbf.so
#    rm -f  $fb/afufile.so
#    rm -f  $fb/afumisc.so
#    rm -f  $fb/afutextfile.so
#    rm -f  $fb/afuxml.so
#    rm -f  $fb/afuzip.so
    rm -f  %{_libdir}/afmmngr.so

#    ln -s $fbdirudf/afcommon.so $fb/afcommon.so
#    ln -s $fbdirudf/afmmngr.so $fb/afmmngr.so
#    ln -s $fbdirudf/afucrypt.so $fb/afucrypt.so
#    ln -s $fbdirudf/afudbf.so $fb/afudbf.so
#    ln -s $fbdirudf/afufile.so $fb/afufile.so
#    ln -s $fbdirudf/afumisc.so $fb/afumisc.so
#    ln -s $fbdirudf/afutextfile.so $fb/afutextfile.so
#    ln -s $fbdirudf/afuxml.so  $fb/afuxml.so
#    ln -s $fbdirudf/afuzip.so $fb/afuzip.so
    ln -s $fbdirudf/afmmngr.so %{_libdir}/afmmngr.so
#fi

ldconfig
#echo "Please restart Firebird server NOW!"

%pre

#if [ -z "`ps ax -o command | grep fbserver | grep -v grep`" ]
#then
#echo  > /dev/stderr
#echo "[Error]: Prior to the beginning of installation firebird service should be started." > /dev/stderr
#echo > /dev/stderr
#exit 1
#service firebird start
#fi

  if [ ! -d /opt/firebird/UDF ]; then 
    #echo > /dev/stderr
    mkdir -p /opt/firebird/UDF
    #echo /opt/firebird not found! Please install FirebirdSS or FirebirdCS > /dev/stderr
    #echo > /dev/stderr
    #exit 1
  fi
%preun

#if [ ! -z "`ps ax -o command | grep fbserver | grep -v grep`" ]
#then
#  #echo  > /dev/stderr
#  #echo "[Error]: Prior to the beginning of installation firebird service should be stoped." > /dev/stderr
#  #echo > /dev/stderr
#  #exit 1
#  service firebird stop
#fi
#exit 0

%postun
rm -f /etc/ld.so.conf.d/firebird-af-udf.conf
ldconfig
echo "Please restart Firebird server NOW!"










