# android_device_huawei_toronto
Huawei Y7 2017/Y7 Prime 2017/Enjoy 7 Plus TWRP Device Tree

## Building Guide:

```
mkdir twrp
cd twrp  
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-7.1 
repo sync 
git clone https://github.com/lpxx50117/android_device_huawei_toronto.git device/huawei/toronto
. build/envsetup.sh 
lunch omni_toronto-userdebug 
export LC_ALL=C 
mka recoveryimage
```

