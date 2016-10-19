    #!/bin/bash

    export LC_ALL=zh_CN.GB2312;
    export LANG=zh_CN.GB2312

    # upload fir function
    function uploadToFir
    {
        #####开始上传，如果只需要打ipa包出来不需要上传，可以删除下面的代码
        export LANG=en_US
        export LC_ALL=en_US;

        #拷贝ipa文件
        cp -f -p $IPA_PATH ./ipa

        #echo "正在上传到fir.im...."
        #fir p $ipa_path -T 28c4de46a75b81b2fdbbedd701120ae7
        #changelog=`cat $PROJECT_PATH/README`
        #echo $changelog
        #
        #curl -X PUT --data "changelog=$changelog" http://fir.im/api/v2/app/56021bece75e2d768a000001?token=28c4de46a75b81b2fdbbedd701120ae7
        #echo "\n打包上传更新成功！"
        #

        export LC_ALL=zh_CN.UTF-8;
        export LANG=zh_CN.UTF-8

        LOG_L1="Version ${BUNDLESHORTVERSION} (${BUNDLEVERSION}) \n${SVN_LOG}"
        #echo -e ${SVN_LOG}
        echo -e "${LOG_L1}" > ${PROJECT_PATH}/ipa/changelog.txt || exit

        export LC_ALL=zh_CN.GB2312;
        export LANG=zh_CN.GB2312

        if [ "${ARG_ENV_PLATFORM}" == "PRD" ]; then
            ## 生产环境的内测发布 fir.im/pamifiprd
            FIR_APP_ID="57d1126aca87a860750001c0"
        else
            ## QA环境的内测发布 fir.im/pamifi
            FIR_APP_ID="575cd32300fc7448e900001c"
        fi
        

        #zhou's app id
        #FIR_APP_ID="5462c5de0a4e70cd6400063d"

        FIR_API_RELEASE="http://api.fir.im/apps/${FIR_APP_ID}/releases"
        FIR_APP_TOKEN="e335c75a9f59dfb38d951862b05ff5c0"
        #zhou's app token
        #FIR_APP_TOKEN="69c8db8d46358058a9352ccaad48ca57"

        FIR_API_RELEASE_JSONPATH="$PROJECT_PATH/ipa/upload.json"

        json=$(curl -o $FIR_API_RELEASE_JSONPATH -s -X "POST" "${FIR_API_RELEASE}" \
        --data-urlencode "type=ios" \
        --data-urlencode "api_token=${FIR_APP_TOKEN}" \
        --data-urlencode "bundle_id=${BUNDLEIDENTIFIER}")

        if [ ! -f "$FIR_API_RELEASE_JSONPATH" ]; then
        echo "ERROR! upload.json is not exists. make it!"
        exit 2
        fi

        UPLOADKEY=$(jq ".cert.binary.key" $FIR_API_RELEASE_JSONPATH | sed 's/\"//g')
        UPLOADTOKEN=$(jq ".cert.binary.token" $FIR_API_RELEASE_JSONPATH | sed 's/\"//g')
        UPLOADURL=$(jq ".cert.binary.upload_url" $FIR_API_RELEASE_JSONPATH | sed 's/\"//g')

        echo $UPLOADKEY
        echo $UPLOADTOKEN
        echo $UPLOADURL

        echo "正在上传到fir.im...."
        #exit 2
        if [ "${ARG_ENV_PLATFORM}" == "PRD" ]; then
            ## 生产环境的内测发布 fir.im/pamifiprd
            APP_NAME="${BUNDLEDISPLAYNAME} 生产环境"
        else
            ## QA环境的内测发布 fir.im/pamifi
            APP_NAME="${BUNDLEDISPLAYNAME} 测试或者QA环境"
        fi
        APP_VERSION="${BUNDLESHORTVERSION}"
        APP_BUILD="${BUNDLEVERSION}"
        APP_CHANGELOG=`cat ${PROJECT_PATH}/ipa/changelog.txt`
        APP_RELEASETYPE="Adhoc"

        curl -X "POST" ${UPLOADURL} \
        -F "x:name=${APP_NAME}" \
        -F "file=@${IPA_PATH}" \
        -F "x:version=${APP_VERSION}" \
        -F "key=${UPLOADKEY}" \
        -F "token=${UPLOADTOKEN}" \
        -F "x:build=${APP_BUILD}" \
        -F "x:changelog=${APP_CHANGELOG}" \
        -F "x:release_type=${APP_RELEASETYPE}" \
        -#

        echo -e '\n'
        echo "upload done!"

        ########################################################################################
    }

    # Help function
    function HELP
    {
        echo -e \\n"${BOLD}持续化集成自动化打包${SCRIPT}${NORM}的帮助文档"\\n
        echo -e "${REV}用法:${NORM} ${BOLD}$SCRIPT 参数${NORM}"\\n
        echo "可选参数:"
        echo "${REV}-p${NORM}  -- iOS build platform PRD QA DEV UAT"
        echo "${REV}-d${NORM}  -- Distribution platform fir|appstore|pyger"
        echo "${REV}-m${NORM}  -- Mobile provisiong profile's path"
        echo -e "${REV}-h${NORM}  -- 显示此帮助并退出"\\n
        echo -e "示例: "
        # echo -e "${BOLD}$SCRIPT -sPingAnMiFi_PRD -cRelease_PRD -i/home/log/objscenesserver21.log.140701-* -o/local/lzsh.log -t/tmp/lzsh.log${NORM}"\\n
        exit 1
    }

    # Set script name variable
    SCRIPT=`basename ${BASH_SOURCE[0]}`

    # Initialize variables to default values
    ARG_ENV_PLATFORM=
    ARG_DISTRIBUTION=
    ARG_MP_PATH=

    # Set fonts for help
    NORM=`tput sgr0`
    BOLD=`tput bold`
    REV=`tput smso`
    FONTBLUE=`tput setaf 5`

    # Check the number of argument. If none are passed, print help and exit.
    if [ $# -eq 0 ]; then
        HELP
    fi

    while getopts :p:d:c:m:h FLAG; do
        case $FLAG in
            p)
                ARG_ENV_PLATFORM=$OPTARG
                ;;
            d)
                ARG_DISTRIBUTION=$OPTARG
                ;;
            m)
                ARG_MP_PATH=$OPTARG
                ;;            
            h) # show help
                HELP
                ;;
            \?) # unrecognized option - show help
                echo -e \\n"非法参数：-${BOLD}$OPTARG${NORM}"
                HELP
                ;;
        esac
    done

    shift $((OPTIND-1)) #  This tells getopts to move on to the next argument

    #######################################################################
    # default mobile provision profile
    MOBILE_PROVISION_PROFILE_PATH="/Users/wendel/Desktop/QuDianSwift/QuFenQiShop/XC_Ad_Hoc_comxulichengfenqi.mobileprovision"
    BUNDLEIDENTIFIER='com.xulicheng.fenqi'
    PROVISIONINGPROFILE='XC_Ad_Hoc_comxulichengfenqi'
    PROVISIONINGPROFILE_NAME='XC_Ad_Hoc_comxulichengfenqi'
    CODE_SIGN_IDENTITY='iPhone Distribution: Beijing Happy Time Technology Co., Ltd. (RA62SRX9C6)'
    IPA_TYPE="adhoc"

    ## parse the mobile provision profile
    echo $ARG_MP_PATH
    if [ $ARG_MP_PATH ] && [ -e $ARG_MP_PATH ]; then
        echo "从指定描述文件中构造参数${BOLD}$ARG_MP_PATH${NORM}"
        MOBILE_PROVISION_PROFILE_PATH=$ARG_MP_PATH
    else
        echo "指定描述文件不存在，根据参数 -d 设置默认参数"
        if [ "${ARG_DISTRIBUTION}" == "appstore" ]; then
            echo "appstore"
            MOBILE_PROVISION_PROFILE_PATH="/Users/wendel/Desktop/QuDianSwift/QuFenQiShop/XC_Ad_Hoc_comxulichengfenqi.mobileprovision"
        else
            MOBILE_PROVISION_PROFILE_PATH="/Users/wendel/Desktop/QuDianSwift/QuFenQiShop/XC_Ad_Hoc_comxulichengfenqi.mobileprovision"
        fi
        echo "${BOLD}$MOBILE_PROVISION_PROFILE_PATH${NORM}"

    fi

    ## 检查从描述文件导出的provisionprofile.plist是否存在，如果已经存在，则删除。
    if [ -e ProvisionProfile.plist ]
    then
        rm -rf ProvisionProfile.plist
    fi
    # parse provision profile 解析 provison profile
    echo "解析描述文件:$MOBILE_PROVISION_PROFILE_PATH-----> 生成:ProvisionProfile.plist"
    security cms -D -i "$MOBILE_PROVISION_PROFILE_PATH" > ProvisionProfile.plist

    if [ ! -e ProvisionProfile.plist ]
    then
        echo "fail to parse provision profile"
        exit -4
    fi

    # generate entitilements.plist
    if [ -z "$entitlements" ] || [ ! -e "$entitlements" ]
    then
        rm -f Entitlements.plist
        /usr/libexec/PlistBuddy -x -c "Print Entitlements" ProvisionProfile.plist > Entitlements.plist
        entitlements="Entitlements.plist"
    fi

    if [ ! -e "$entitlements" ]
    then
        echo "No entitlement file"
        exit -5
    fi

    MP_APPID=`/usr/libexec/PlistBuddy -c "Print application-identifier" $entitlements`
    # echo "application-identifier is:${MP_APPID}"

    MP_APPID_PREFIX=`/usr/libexec/PlistBuddy -c "Print com.apple.developer.team-identifier" $entitlements`
    # echo ${MP_APPID_PREFIX}

    MP_APPID_IDENTIFIER=${MP_APPID#${MP_APPID_PREFIX}.}
    # echo "MP_APPID_IDENTIFIER:${MP_APPID_IDENTIFIER}"
    # mobileprovision_uuid=`/usr/libexec/PlistBuddy -c "Print UUID" /dev/stdin <<< $(/usr/bin/security cms -D -i $1)`
    MP_UUID=`/usr/libexec/PlistBuddy -c "Print UUID" ProvisionProfile.plist`
    # echo "UUID is:${MP_UUID}"

    MP_NAME=`/usr/libexec/PlistBuddy -c "Print Name" ProvisionProfile.plist`
    # echo "name is:${MP_NAME}"

    # mobileprovision_teamname=`/usr/libexec/PlistBuddy -c "Print TeamName" /dev/stdin <<< $(/usr/bin/security cms -D -i $1)`
    MP_TEAMNAME=`/usr/libexec/PlistBuddy -c "Print TeamName" ProvisionProfile.plist`
    # echo "TeamName is:${MP_TEAMNAME}"

    BUNDLEIDENTIFIER="$MP_APPID_IDENTIFIER"
    PROVISIONINGPROFILE="$MP_UUID"
    PROVISIONINGPROFILE_NAME="$MP_NAME"
    CODE_SIGN_IDENTITY="iPhone Distribution: $MP_TEAMNAME"

    # 构造 scheme和build config参数，用于生成不同后台API环境的ipa
    if [ -z "$ARG_ENV_PLATFORM" ]; then
        echo "使用默认环境${BOLD}QA${NORM}"
        BUILD_SCHEME="${PROJECT_NAME}"
        BUILD_CONFIG="Debug"

    fi

    #开发证书打包
    if [ "${ARG_ENV_PLATFORM}" == "QA" ]; then
        echo "使用QA环境${BOLD}QA${NORM}"
        BUILD_SCHEME="${PROJECT_NAME}"
        BUILD_CONFIG="Debug"
    fi

    #生产证书AppStore
    if [ "${ARG_ENV_PLATFORM}" == "PRD" ]; then
        echo "使用生产环境${BOLD}Production${NORM}"
        BUILD_SCHEME="${PROJECT_NAME}"
        BUILD_CONFIG="Release"

    fi

    #生产证书AdHoc
    if [ "${ARG_ENV_PLATFORM}" == "UAT" ]; then
        echo "使用UAT环境${BOLD}UAT${NORM}"
        BUILD_SCHEME="${PROJECT_NAME}"
        BUILD_CONFIG="Release"
    fi








    ## 如果是发布到appstore的ipa，必须使用生产环境的scheme，build setting，
    if [ "${ARG_DISTRIBUTION}" == "appstore" ]; then
        echo "${BOLD}生成用于发布到Appstore的ipa文件${NORM}"
        # BUNDLEIDENTIFIER='com.pingancm.mifi'
        # PROVISIONINGPROFILE='272b14bf-a8d1-4bf5-af0a-ec688303dd93'
        # PROVISIONINGPROFILE_NAME='mifi_dis'
        # CODE_SIGN_IDENTITY='"iPhone Distribution: Shenzhen Ping An Communication Technology Co.,Ltd (Q4F4DQKW5D)"'
        BUILD_SCHEME="${PROJECT_NAME}"
        BUILD_CONFIG="Release"
        IPA_TYPE="appstore"
    fi

    echo "${FONTBLUE}描述文件参数 ${NORM}"
    echo "${FONTBLUE}${BUNDLEIDENTIFIER}${NORM}"
    echo "${FONTBLUE}${PROVISIONINGPROFILE_NAME}${NORM}"
    echo "${FONTBLUE}${PROVISIONINGPROFILE}${NORM}"
    echo "${FONTBLUE}${CODE_SIGN_IDENTITY}${NORM}"

    #######################################################################
    # 以下是与工程和workspace相关的参数初始化

    # init build configuration
    PROJECT_PATH=$(pwd)
    echo "$PROJECT_PATH"


    # archive and ipa output path
    BUILD_PATH="$PROJECT_PATH/build"

    # workspace name
    BUILD_WORKSPACE=$(ls | grep xcworkspace | awk -F.xcworkspace '{print $0}')
    echo "BUILD_WORKSPACE******$BUILD_WORKSPACE"

    # project name and path
    PROJECT_NAME=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
    echo "PROJECT_NAME******$PROJECT_NAME"

    # workspace name
    BUILD_PROJECT=$PROJECT_NAME.xcodeproj
    echo "$PROJECT_PATH/$BUILD_PROJECT"

    # provisiong profile name
    # PROVISIONINGPROFILE='"zzt-adhoc-20141119"'

    # timestamp for ouput file name
    TIMESTAMP="$(date +"%Y%m%d_%H%M%S")"

    #echo "$PROJECT_PATH/$BUILD_WORKSPACE"
    #if [ ! -d "$PROJECT_PATH/$BUILD_WORKSPACE" ]; then
    #	echo  "Error!Current path is not a xcode workspace.Please check, or do not use -w option."
    #	exit 2
    #fi 

    if [ ! -d "$PROJECT_PATH/$BUILD_PROJECT" ]; then
    	echo  "Error!Current path is not a xcode project.Please check, or do not use -p option."
    	exit 2
    fi 

    cd $PROJECT_PATH
    if [ ! -d "$BUILD_PATH" ]; then
    	echo "Build direcotry is not exists. make it!" 
        mkdir -pv $BUILD_PATH
    fi


    # get the info.plist
    APP_INFOPLIST_PATH=${PROJECT_PATH}/${PROJECT_NAME}/${PROJECT_NAME}-Info.plist
    echo ${APP_INFOPLIST_PATH}

    # get the main version
    BUNDLESHORTVERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${APP_INFOPLIST_PATH}")

    # get the build version
    BUNDLEVERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${APP_INFOPLIST_PATH}")

    BUNDLEDISPLAYNAME=$(/usr/libexec/PlistBuddy -c "print CFBundleDisplayName" "${APP_INFOPLIST_PATH}")

    export LC_ALL=zh_CN.UTF-8;
    export LANG=zh_CN.UTF-8
    # scheme name
    BUILD_SCHEME="${PROJECT_NAME}"
    #BUILD_SCHEMES=("app" "app_QA" "app_UAT" "app_PRD") 
    BUILD_SCHEMES=($BUILD_SCHEME) 
    #BUILD_CONFIGS=("Release" "Release_QA" "Release_UAT" "Release_PRD")
    BUILD_CONFIGS=($BUILD_CONFIG)
    for i in "${!BUILD_CONFIGS[@]}";
    do 
        CONFIG=${BUILD_CONFIGS[$i]}
        BUILD_SCHEME=${BUILD_SCHEMES[$i]}
        printf "%s\t%s\t%s\n" "$i" "${CONFIG}" "${BUILD_SCHEME}"
        
        CONFIG_LOWCASE=$(echo $CONFIG | tr '[A-Z]' '[a-z]') 
        
        CLEAN_CMD='xcodebuild'
        
        #used by workspace
        CLEAN_CMD=${CLEAN_CMD}' clean -workspace '${BUILD_WORKSPACE}' -scheme '${BUILD_SCHEME}' -configuration '${CONFIG}
        #used by project                           
        echo $CLEAN_CMD
        $CLEAN_CMD >  $BUILD_PATH/clean_qa.txt || exit
        
        # build & archive, generate the archive file
        ARCHIVE_NAME="${PROJECT_NAME}_${CONFIG_LOWCASE}_${TIMESTAMP}.xcarchive"
        ARCHIVE_PATH="./build/"$ARCHIVE_NAME 

        BUILD_CMD='xcodebuild 
        -workspace '${BUILD_WORKSPACE}'
        -scheme '${BUILD_SCHEME}'
        -destination generic/platform=iOS archive 
        -configuration '${CONFIG}' ONLY_ACTIVE_ARCH=NO 
        -archivePath '"${ARCHIVE_PATH}"'
        "PRODUCT_BUNDLE_IDENTIFIER='${BUNDLEIDENTIFIER}'" 
        "CODE_SIGN_IDENTITY='${CODE_SIGN_IDENTITY}'" 
        "PROVISIONING_PROFILE='${PROVISIONINGPROFILE}'"'

        
        echo "** Archiving to the ${ARCHIVE_PATH}"
        echo ${BUILD_CMD}

        xcodebuild \
        -workspace ${BUILD_WORKSPACE} \
        -scheme ${BUILD_SCHEME} \
        -destination generic/platform=iOS archive \
        -configuration ${CONFIG} ONLY_ACTIVE_ARCH=NO \
        -archivePath "${ARCHIVE_PATH}" \
        "PRODUCT_BUNDLE_IDENTIFIER=${BUNDLEIDENTIFIER}" \
        "CODE_SIGN_IDENTITY=${CODE_SIGN_IDENTITY}" \
        "PROVISIONING_PROFILE=${PROVISIONINGPROFILE}" \
         > ./build/build_archive_${CONFIG_LOWCASE}.log || exit
        
        if [ ! -d "${ARCHIVE_PATH}" ]; then
        	echo  "** Error! ARCHIVE FAILED ** Please check ./build/build_archive_${CONFIG_LOWCASE}.log."
        	exit 2
        else
        	echo "** ARCHIVE SUCCEEDED ** to the ${ARCHIVE_PATH}"
        fi 
        
        ########################################################################################
        # export to ${IPA_TYPE} ipa with config
        ########################################################################################
        
        IPA_NAME="${PROJECT_NAME}_${IPA_TYPE}_${CONFIG_LOWCASE}_v${BUNDLESHORTVERSION}_b${BUNDLEVERSION}_rev${BUNDLEVERSION}_t${TIMESTAMP}.ipa"
        IPA_PATH="./build/"$IPA_NAME
        
        
        EXPORT_IPA_CMD='xcodebuild'
#XC Ad Hoc: com.xulicheng.fenqi
#${PROVISIONINGPROFILE_NAME}
        EXPORT_IPA_CMD=${EXPORT_IPA_CMD}' -exportArchive -exportFormat ipa -archivePath '${ARCHIVE_PATH}' -exportPath '${IPA_PATH}' -exportProvisioningProfile ''XC\ Ad\ Hoc:\ com.xulicheng.fenqi'

        echo "** Exporting ${IPA_TYPE} ipa to the ${IPA_PATH}"
        echo ${EXPORT_IPA_CMD}
        eval ${EXPORT_IPA_CMD} > ./build/export_ipa_${CONFIG_LOWCASE}.log || exit
        
        if [ ! -f "${IPA_PATH}" ]; then
        	echo "** Error! Export ${IPA_TYPE} ipa FAILED ** Please check ./build/export_ipa_${CONFIG_LOWCASE}.log."
        	exit 2
        else
        	echo "** SUCCEEDED! Export ${IPA_TYPE} ipa ** to the ${IPA_PATH}"
        fi

        echo "${ARG_DISTRIBUTION}"
        if [ "${ARG_DISTRIBUTION}" == "fir" ]
        then 
           # uploadToFir
            echo "${ARG_DISTRIBUTION}"
        fi

    done


    exit 0








    		
