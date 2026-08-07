# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://aur.archlinux.org/packages/navidrome-git

EAPI=8

inherit go-module

DESCRIPTION="Navidrome is a self-hosted, open source music server and streamer."
HOMEPAGE="https://www.navidrome.org"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="https://github.com/navidrome/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/navidrome/navidrome/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3.0"
SLOT="0"
#IUSE=""

DEPEND="media-video/ffmpeg
		"
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/go
		>=net-libs/nodejs-24*
		"

if [[ "${PV}" == *9999* ]]; then
src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
}
fi

src_configure() {

}

src_compile() {
}

src_install() {
}

pkg_postinst() {
}

pkg_postrm() {
}
