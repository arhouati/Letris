#!/bin/sh

# check if the entitlements file is set in the project configuration
if [ "${CODE_SIGN_ENTITLEMENTS}" == "" ]; then
	echo "No entitlements file found in project configuration"
	exit 0
fi

# create full path to entitlements file from the project configuration
ENTITLEMENTS_FILE_PATH=${SRCROOT}/${CODE_SIGN_ENTITLEMENTS}

# check if the entitlements file exists on disk
if [ ! -f ${ENTITLEMENTS_FILE_PATH} ]; then
	echo "Entitlements file not found at path '${ENTITLEMENTS_FILE_PATH}'"
	exit 1
fi

#echo "Entitlements file path = '${ENTITLEMENTS_FILE_PATH}'"
#echo "Code sign identity = '${CODE_SIGN_IDENTITY}'"

# get the current value for the get-task-allow key (muting the error to avoid warning if the key doesn't exist)
CURRENT_GET_TASK_ALLOW=$(/usr/libexec/PlistBuddy -c "Print get-task-allow" ${ENTITLEMENTS_FILE_PATH} 2> /dev/null)
#echo "Current 'get-task-allow' value = '${CURRENT_GET_TASK_ALLOW}'"

# define the new 'get-task-allow' value depending on the code sign identity
if [[ "${CODE_SIGN_IDENTITY}" == "iPhone Developer"* ]]; then
	GET_TASK_ALLOW=true
else
	GET_TASK_ALLOW=false
fi

# no need to write in the file if the value is properly set
if [ "${CURRENT_GET_TASK_ALLOW}" == "${GET_TASK_ALLOW}" ]; then
	echo "No need to update entitlements file, 'get-task-allow' already set to '${GET_TASK_ALLOW}'"
	exit 0
fi

# we need to use different command if the value exist in the file or doesn't
if [ "${CURRENT_GET_TASK_ALLOW}" == "" ]; then
	echo "Adding 'get-task-allow' to '${ENTITLEMENTS_FILE_PATH}' with value '${GET_TASK_ALLOW}'"
	/usr/libexec/Plistbuddy -c "Add :get-task-allow bool ${GET_TASK_ALLOW}" ${ENTITLEMENTS_FILE_PATH}
else
	echo "Updating 'get-task-allow' in '${ENTITLEMENTS_FILE_PATH}' with value '${GET_TASK_ALLOW}'"
	/usr/libexec/Plistbuddy -c "Set :get-task-allow ${GET_TASK_ALLOW}" ${ENTITLEMENTS_FILE_PATH}
fi

# verification output
#NEW_GET_TASK_ALLOW=$(/usr/libexec/PlistBuddy -c "Print :get-task-allow" ${ENTITLEMENTS_FILE_PATH})
#echo "New 'get-task-allow' value = ${NEW_GET_TASK_ALLOW}"

exit 0