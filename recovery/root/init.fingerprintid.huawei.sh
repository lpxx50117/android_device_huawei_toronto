#!sbin/sh

#
# use ro.build.fingerprint from system/build.prop instead of default.prop
#

propkeyn="ro.build.product;ro.product.name;ro.product.board;ro.product.model;ro.product.device;ro.build.description;ro.build.fingerprint"
propvaln="^hi6250;^BLN-;^hi6250;^BLN-;^HWBLN;.*;.*"

systempart=`find /dev/block -name system | grep "by-name/system" -m 1 2>/dev/null`

ismount="0"
ismount_str=`mount | grep -F "/system "`
if [ -n "$ismount_str" ] ;then
  ismount="1"
else
  ismount="0"
  mount -o ro "$systempart" /system
fi
#--
mount -o ro /dev/block/bootdevice/by-name/product /product
hw_oem=`cat "/sys/firmware/devicetree/base/hisi,product_name" 2>/dev/null | grep -F "BLN-"`
prop_path=
if [ -n "$hw_oem" ];then
  if [ -f "/product/hw_oem/$hw_oem/prop/local.prop" ];then
    prop_path="/product/hw_oem/$hw_oem/prop/local.prop"
  fi
  if [ -f "/system/hw_oem/$hw_oem/prop/local.prop" ];then
    prop_path="/system/hw_oem/$hw_oem/prop/local.prop"
  fi
fi
#--

for i in 1 2 3 4 5 6 7
do
propkey=`echo "$propkeyn" | awk -F ';' "{print \\$$i}" 2>/dev/null`
propval=`echo "$propvaln" | awk -F ';' "{print \\$$i}" 2>/dev/null`

isget=`getprop "$propkey"`
if [ -z "$isget" ] ;then
  
  deffingerprint=`cat /default.prop | grep -F "$propkey=" -m 1 | awk -F '=' '{print $2 }' 2>/dev/null`
  if [ -e /system/build.prop ] ;then
    fingerprint=`cat $prop_path /system/build.prop | grep -F "$propkey=" -m 1 | awk -F '=' '{print $2 }' 2>/dev/null | grep "$propval"`
    if [ -z "$fingerprint" ] ;then
      setprop "$propkey" "$deffingerprint"
    else
      setprop "$propkey" "$fingerprint"
    fi
  else
    setprop "$propkey" "$deffingerprint"
  fi
fi
done

if [ "$ismount" = "0" ] ;then
  umount /system
fi


exit 0




