#!/bin/sh

# on se deplace dans le repertoire racine du projet
cd ${SRCROOT}

# fonction pour verifier si on se trouve dans un repertoire sous controle de version via SVN
function in_svn() {
	if [[ -d .svn ]]; then
		echo 1
	fi
}

# renvoie le numero de revision courant
function svn_get_rev_nr {
	if [ $(in_svn) ]; then
		svn info 2> /dev/null | sed -n s/Revision:\ //p
	fi
}

PLIST_FILE_PATH=${PROJECT_DIR}/${INFOPLIST_FILE}

if [ "${INFOPLIST_FILE}" == "" ]; then
	echo "No Info.plist file found in project configuration"
	exit 0
fi

if [ ! -f ${PLIST_FILE_PATH} ]; then
	echo "Info.plist file not found at path ${PLIST_FILE_PATH}"
	exit 1
fi


# recupere le numero de version, ex : 1.0
CF_BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${PLIST_FILE_PATH}" 2> /dev/null)

# recupere le numero de revision, ex : 116
CF_BUNDLE_SHORT_VERSION_STRING=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${PLIST_FILE_PATH}" 2> /dev/null)

echo "Current CFBundleVersion = ${CF_BUNDLE_VERSION}"
echo "Current CFBundleShortVersionString = ${CF_BUNDLE_SHORT_VERSION_STRING}"

# recupere le numero de revision SVN, ex : 117
BUILD_NUMBER=$(svn_get_rev_nr)
echo "Current SVN revision = ${BUILD_NUMBER}"

# defini le nouveau numero de version complet, ex : 117
/usr/libexec/Plistbuddy -c "Set :CFBundleVersion ${BUILD_NUMBER}" "${PLIST_FILE_PATH}"

# recupere le numero de version, ex : 1.0
NEW_CF_BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${PLIST_FILE_PATH}" 2> /dev/null)

# recupere le numero de revision, ex : 116
NEW_CF_BUNDLE_SHORT_VERSION_STRING=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${PLIST_FILE_PATH}" 2> /dev/null)

# output de verification
echo "New CFBundleVersion = ${NEW_CF_BUNDLE_VERSION}"
echo "New CFBundleShortVersionString = ${NEW_CF_BUNDLE_SHORT_VERSION_STRING}"

exit 0