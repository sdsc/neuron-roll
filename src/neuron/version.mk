PKGROOT            = /opt/neuron
NAME               = neuron
VERSION            = 7.3
RELEASE            = 1
TARBALL_POSTFIX    = tgz

SRC_SUBDIR         = neuron

SOURCE_NAME        = nrn
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)
RPM.EXTRAS         = AutoReq:No
