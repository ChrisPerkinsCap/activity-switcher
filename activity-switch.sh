#!/bin/bash

set -e

command="switch-act"

SETTINGS_WORK_SYMLINK="/Users/$USER/.m2/settings.xml"
SETTINGS_WORK_FILE="/Users/$USER/.m2/settings-travail.xml"
TRAIN="train"
WORK="work"


#
# Early exit if no arguments are passed in
#
if [[ "${#}" -eq 0 ]]
then
  echo "No arguments passed in. Script exiting" 1>&2
  exit 1
fi

#
# Early exit if too many arguments are passed in
#
if [[ "${#}" -gt 2 ]]
then
  echo "Too many arguments passed in. Script exiting" 1>&2
  exit 2
fi

#
# Early exit if argument $1 is not "switch-act"
#
# if [[ "${1}" =~ ^(training|work)$ ]]
if [[ "${1}" != "${TRAIN}" ]] && [[ "${1}" != "${WORK}" ]]
then
  echo "${1} is not 'train' or 'work'
       Please verify where this script is being called from." 1>&2
  exit 4
fi

#
# Remove the symbolic link to the settings-travail.xml file
# to prevent Maven from using the corporate infrastructure from
# building artifacts.
#
setup_training_environment() {

  if [[ -f "${SETTINGS_WORK_SYMLINK}" ]]
  then
    echo "Setting up Maven for training"
    rm "${SETTINGS_WORK_SYMLINK}"
  else
    echo "This machine is already in 'Training' mode!"
  fi
}

#
# Create a symbolic link to the settings-travail.xml file
# to make Maven use the corporate infrastructure to building artifacts.
#
setup_working_environment() {
  if [[ ! -f "$SETTINGS_WORK_SYMLINK" ]]
  then
    echo "Setting up Maven for work"
    ln -s "${SETTINGS_WORK_FILE}" "${SETTINGS_WORK_SYMLINK}"
  else
    echo "This machine is already in 'Work' mode!"
  fi
}

#
# Receives one argument and calls the apropriate function based on its'
# value.
#
# $activity = ( work || training )
#
switch_activities() {

  activity=${1}

  if [[ "${activity}" == "${TRAIN}" ]]
  then
    setup_training_environment
  fi

  if [[ "${activity}" == "${WORK}" ]]
  then
    setup_working_environment
  fi

}

switch_activities "${1}"

#exec "${@}"

exit ${$}
