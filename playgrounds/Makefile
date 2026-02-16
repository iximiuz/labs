CUR_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

IMAGE_REPOSITORY ?= ghcr.io/iximiuz/labs/rootfs

ROOTFS_DIRS := $(shell find $(CUR_DIR) -type d -name "[0-9]*.rootfs-*" -exec basename {} \; | sort -u)
TAGS := $(foreach dir, $(ROOTFS_DIRS), $(shell echo $(dir) | sed -e 's/[0-9]*.rootfs-//'))
BASE_1XX_TAGS := $(foreach dir, $(ROOTFS_DIRS), $(shell echo $(dir) | grep -E "^1[0-9][0-9]\." | sed -e 's/[0-9]*.rootfs-//'))
BASE_2XX_TAGS := $(foreach dir, $(ROOTFS_DIRS), $(shell echo $(dir) | grep -E "^2[0-9][0-9]\." | sed -e 's/[0-9]*.rootfs-//'))
BASE_3XX_TAGS := $(foreach dir, $(ROOTFS_DIRS), $(shell echo $(dir) | grep -E "^3[0-9][0-9]\." | sed -e 's/[0-9]*.rootfs-//'))
BASE_4XX_TAGS := $(foreach dir, $(ROOTFS_DIRS), $(shell echo $(dir) | grep -E "^4[0-9][0-9]\." | sed -e 's/[0-9]*.rootfs-//'))
BASE_5XX_TAGS := $(foreach dir, $(ROOTFS_DIRS), $(shell echo $(dir) | grep -E "^5[0-9][0-9]\." | sed -e 's/[0-9]*.rootfs-//'))

define find_rootfs_dir
$(shell find $(CUR_DIR) -type d -name "[0-9]*.rootfs-$(1)" -exec basename {} \;)
endef


.PHONY: all
all: $(addprefix push-rootfs-, $(TAGS))
	@echo "\033[0;32mDone all!\033[0m"

.PHONY: base-1xx
base-1xx: $(addprefix push-rootfs-, $(BASE_1XX_TAGS))
	@echo "\033[0;32mDone all!\033[0m"

.PHONY: base-2xx
base-2xx: $(addprefix push-rootfs-, $(BASE_2XX_TAGS))
	@echo "\033[0;32mDone all!\033[0m"

.PHONY: base-3xx
base-3xx: $(addprefix push-rootfs-, $(BASE_3XX_TAGS))
	@echo "\033[0;32mDone all!\033[0m"

.PHONY: base-4xx
base-4xx: $(addprefix push-rootfs-, $(BASE_4XX_TAGS))
	@echo "\033[0;32mDone all!\033[0m"

.PHONY: snapshot-all
snapshot-all: $(addprefix snapshot-rootfs-, $(TAGS))
	@echo "\033[0;32mDone all!\033[0m"

.PHONY: snapshot-rootfs-%
snapshot-rootfs-%:
	@if [ -z "${RELEASE}" ]; then \
		echo "\033[0;31mERROR: RELEASE variable must be set\033[0m"; \
		exit 1; \
	fi
	@echo "\033[0;32mSnapshotting rootfs $*-${RELEASE} as $*...\033[0m"
	crane tag ${IMAGE_REPOSITORY}:$*-${RELEASE} $*
	@echo "\033[0;32mDone!\033[0m"

.PHONY: build-rootfs-%
build-rootfs-%: examiner examinerctl
	@if [ -z "${RELEASE}" ]; then \
		echo "\033[0;31mERROR: RELEASE variable must be set\033[0m"; \
		exit 1; \
	fi
	@echo "\033[0;32mBuilding rootfs $* (release: ${RELEASE})...\033[0m"
	docker build \
		--progress plain \
		--build-arg ROOTFS_RELEASE=${RELEASE} \
		--build-arg LAB_USER=laborant \
		--build-arg ARKADE_BIN_DIR=/usr/local/bin \
		--build-arg ALMALINUX_VERSION=9 \
		--build-arg ALPINE_VERSION=3 \
		--build-arg BTOP_VERSION=1.4.4 \
		--build-arg CFSSL_VERSION=1.6.5 \
		--build-arg DAGGER_VERSION=0.18.12 \
		--build-arg DEBIAN_STABLE_VERSION=bookworm \
		--build-arg DEBIAN_TESTING_VERSION=trixie \
		--build-arg DIVE_VERSION=0.13.1 \
		--build-arg FEDORA_VERSION=42 \
		--build-arg GOLANG_VERSION=1.24.4 \
		--build-arg K0S_VERSION=1.33.2+k0s.0 \
		--build-arg K0S_KUBECTL_VERSION=1.33.2 \
		--build-arg K3S_VERSION=1.33.2+k3s1 \
		--build-arg K3S_KUBECTL_VERSION=1.33.2 \
		--build-arg K8S_OMNI_VERSION=1.33.2 \
		--build-arg K8S_OMNI_CNI_PLUGINS_VERSION=1.7.1 \
		--build-arg K8S_OMNI_CONTAINERD_VERSION=2.1.3 \
		--build-arg K8S_OMNI_CRI_O_VERSION=1.32.1 \
		--build-arg K8S_OMNI_CRICTL_VERSION=1.33.0 \
		--build-arg K8S_OMNI_RUNC_VERSION=1.3.0 \
		--build-arg K9S_VERSION=0.50.7 \
		--build-arg KAMAL_VERSION=2.7.0 \
		--build-arg NERDCTL_VERSION=2.1.2 \
		--build-arg NERDCTL_CNI_VERSION=1.7.1 \
		--build-arg NVM_VERSION=0.40.3 \
		--build-arg PYTHON_VERSION=3.13 \
		--build-arg ROCKYLINUX_VERSION=9 \
		--build-arg MINTOOLKIT_VERSION=1.41.7 \
		--build-arg TETRAGON_VERSION=1.4.0 \
		--build-arg WEBSOCAT_VERSION=1.14.0 \
		--build-arg ZIG_VERSION=0.14.1 \
		-t ${IMAGE_REPOSITORY}:$*-${RELEASE} \
		-f ${CUR_DIR}/$(call find_rootfs_dir,$*)/Dockerfile \
		${CUR_DIR}/
	@echo "\033[0;32mDone!\033[0m"

.PHONY: push-rootfs-%
push-rootfs-%: build-rootfs-%
	@if [ -z "${RELEASE}" ]; then \
		echo "\033[0;31mERROR: RELEASE variable must be set\033[0m"; \
		exit 1; \
	fi
	@echo "\033[0;32mPushing rootfs $*-${RELEASE}...\033[0m"
	docker push ${IMAGE_REPOSITORY}:$*-${RELEASE}
	@echo "\033[0;32mDone!\033[0m"

.PHONY: examiner
examiner:
	cp ${CUR_DIR}/../../bin/examiner ${CUR_DIR} || true

.PHONY: examinerctl
examinerctl:
	cp ${CUR_DIR}/../../bin/examinerctl ${CUR_DIR} || true

clean-rootfs-%:
	docker rmi ${IMAGE_REPOSITORY}:$*-${RELEASE} || true
	docker rmi ${IMAGE_REPOSITORY}:$* || true

.PHONY: clean-all
clean-all: $(addprefix clean-rootfs-, $(TAGS))
	rm -f ${CUR_DIR}/examiner
	rm -f ${CUR_DIR}/examinerctl
	@echo "\033[0;32mDone all!\033[0m"
