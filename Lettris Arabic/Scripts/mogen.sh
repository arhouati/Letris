#!/bin/sh
#  mogen.sh
#

echo mogenerator --model "${INPUT_FILE_PATH}" --machine-dir \"SmartKnowledge/Classes/Models/Abstract/\" --human-dir \"SmartKnowledge/Classes/Models/\"
mogenerator --model "${INPUT_FILE_PATH}" --machine-dir "SmartKnowledge/Classes/Models/Abstract/" --human-dir "SmartKnowledge/Classes/Models/"

echo ${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.6 \"${INPUT_FILE_PATH}\" \"${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.mom\"
${DEVELOPER_BIN_DIR}/momc -XD_MOMC_TARGET_VERSION=10.6 "${INPUT_FILE_PATH}" "${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/${INPUT_FILE_BASE}.mom"

echo "that's all folks. mogen.sh is done"