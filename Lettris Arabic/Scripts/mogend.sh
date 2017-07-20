#!/bin/sh
#  mogend.sh
#

#  If no custom MO class is required, remove the "--base-class $baseClass" parameter from mogenerator call
curVer=`/usr/libexec/PlistBuddy "${INPUT_FILE_PATH}/.xccurrentversion" -c 'print _XCCurrentVersionName'`

echo mogenerator --model \"${INPUT_FILE_PATH}/$curVer\" --output-dir \"SmartKnowledge/Classes/Models/\" 
mogenerator --model "${INPUT_FILE_PATH}/$curVer" --machine-dir "SmartKnowledge/Classes/Models/Abstract/" --human-dir "SmartKnowledge/Classes/Models/"

echo ${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.6 \"${INPUT_FILE_PATH}\" \"${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.momd\"
${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.6 "${INPUT_FILE_PATH}" "${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.momd"