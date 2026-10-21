# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson git-r3

DESCRIPTION="A pure-C API to the dinitctl socket of the dinit service manager"
HOMEPAGE="https://github.com/chimera-linux/libdinitctl"
EGIT_REPO_URI="https://github.com/chimera-linux/libdinitctl.git"

LICENSE="BSD-2-Clause"
SLOT="0"
KEYWORDS=""

#IUSE="+udev"

DEPEND="sys-apps/dinit"
RDEPEND="${DEPEND}"
BDEPEND="dev-build/meson"

src_unpack() {
	git-r3_src_unpack
}

src_configure() {
#	$(meson_feature udev libudev )
	meson_src_configure
}

src_install() {
	meson_src_install
}


