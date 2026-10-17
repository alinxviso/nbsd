# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="A program enabling web-installation of items via OpenCollaborationServices"
HOMEPAGE="https://opendesktop.org/p/1136805"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://www.opencode.net/dfn2/${PN}.git"
else
	SRC_URI="https://git.opendesktop.org/akiraohgaki/${PN}/-/archive/release-${PV}/${PN}-release-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-release-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtbase:6
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
"

RDEPEND="${DEPEND}"

if [[ ${PV} == 9999 ]]; then
	src_unpack() {
		git-r3_src_unpack

		unset EGIT_BRANCH EGIT_COMMIT
		EGIT_REPO_URI=https://github.com/akiraohgaki/qtil.git
		EGIT_CHECKOUT_DIR="${S}/lib/qtil"
		git-r3_src_unpack
	}
fi

src_prepare(){
	./scripts/prepare || die
	default_src_prepare
	eapply "${FILESDIR}"/allow-build-on-qt6.patch
}

src_configure(){
	eqmake6 PREFIX="/usr"
}

src_install(){
	INSTALL_ROOT="${D}" default_src_install
}

pkg_postinst(){
	xdg_pkg_postinst
	elog "You can install packages from any page from https://www.opendesktop.org or"
	elog "related Sites. Just click on \"Install\", and then open the \"ocs://\" url"
	elog "provided by every package."
}
