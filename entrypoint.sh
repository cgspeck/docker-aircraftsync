#! /bin/bash -e
function delete_sync_user_if_exists() {
  if grep syncuser /etc/passwd &> /dev/null; then
    echo "Deleting existing syncuser"
    userdel syncuser
  fi
}

if ! grep $PGID /etc/group &> /dev/null; then
  if grep syncuser /etc/group &> /dev/null; then
    delete_sync_user_if_exists
    echo "Deleting existing syncuser group"
    groupdel syncuser
  fi
  echo "Creating syncuser group"
  groupadd -g $PGID syncuser
fi

GROUP_NAME=$(grep ":x:${PGID}" /etc/group | cut -f 0 -d':')

if ! grep ":x:${PUID}" /etc/passwd; then
  delete_sync_user_if_exists
  echo "Creating syncuser user"
  useradd -l -r -m -g $PGID -u $PUID syncuser
fi

USER_NAME=$(grep ":x:${PUID}" /etc/passwd | cut -f0 -d':')

DEST="/dist/Aircraft"
CHECKOUT_CMD="exec su ${USER_NAME} -c \"/usr/bin/svn checkout $URL /dist\""
CLEANUP_CMD="exec su ${USER_NAME} -c \"/usr/bin/svn cleanup $DEST\""
UPDATE_CMD="exec su ${USER_NAME} -c \"/usr/bin/svn up $DEST\""

chown -R $PUID:$PGID /dist
chmod g+s /dist

if [[ $# -eq 1 ]]; then
  case "$1" in
    "cleanup" )
      eval $CLEANUP_CMD
      ;;
    "console" )
      exec su ${USER_NAME}
      ;;
    "root" )
      exec /bin/bash
      ;;
  esac
fi


if [[ -d $DEST ]]; then
  if [ ! /usr/bin/svn info $DEST | grep "${URL}" ]; then
    echo "backing up existing Aircraft checkout."
    mv $DEST /dist/Aircraft.bak
    echo "Doing a fresh checkout"
    eval $CHECKOUT_CMD
  fi
  echo "Updating local repository"
  chown -R $PUID:$PGID $DEST
  eval $UPDATE_CMD
else
  echo "Doing a fresh checkout"
  eval $CHECKOUT_CMD
fi
