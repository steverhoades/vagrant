echo "Starting php-uv installation..."
CURDIR=$(pwd)

git clone https://github.com/chobie/php-uv.git --recursive
cd php-uv
make -C libuv CFLAGS=-fPIC
phpize
./configure 
make
sudo make install

php_config=$(which php-config)
extension_dir=$($php_config --extension-dir)
php_bin=$(which php)

sudo echo "extension=uv.so" >> /etc/php5/mods-available/php-uv.ini
sudo ln -s /etc/php5/mods-available/php-uv.ini /etc/php5/cli/conf.d/20-php-uv.ini

if [ $($php_bin -m | grep uv | wc -l) -eq 1 ]; then
    echo "Installation of php-uv successful"
else
    echo "Fail installing uv.so extension to $extension_dir"
fi 

# WORK IN PROGRESS - Currently failing due to "Cannot find libevent headers"
# # cleanup php-uv
# cd $CURDIR
# rm -fr php-uv

# echo "Starting libevent installation..."
# wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
# tar xzvf libevent-2.0.21-stable.tar.gz 
# cd libevent-2.0.21-stable/
# ./configure
# make 
# sudo make install

# # cleanup libevent
# cd $CURDIR
# rm -fr libevent-2.0.21-stable

# echo "Starting installation of LibEvent PECL extension..."
# pecl_installer=$(which pecl)
# sudo $pecl_installer install channel://pecl.php.net/libevent-0.1.0

# echo "extension=libevent.so" >> /etc/php5/mods-available/libevent.ini
# sudo ln -s /etc/php5/mods-available/libevent.ini /etc/php5/cli/conf.d/20-libevent.ini
# if [ $($php_bin -m | grep libevent | wc -l) -eq 1 ]; then
#     echo "Installation of libevent successful"
# else
#     echo "Fail installing libevent.so extension to $extension_dir"
# fi 