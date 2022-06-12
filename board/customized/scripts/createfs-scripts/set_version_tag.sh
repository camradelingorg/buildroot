#!/bin/bash
VERSION_TAG=$(git describe --tags --dirty=-dirty)
echo "export VERSION_TAG=${VERSION_TAG}" > ${TARGET_DIR}/etc/profile.d/version_tag.sh
echo "INFO: version tag=${VERSION_TAG} exported"
