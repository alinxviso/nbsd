# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://aur.archlinux.org/packages/navidrome-git and https://www.navidrome.org/docs/installation/build-from-source

EAPI=8

inherit go-module systemd

DESCRIPTION="Navidrome is a self-hosted, open source music server and streamer."
HOMEPAGE="https://www.navidrome.org"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="https://github.com/navidrome/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/navidrome/navidrome/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	#SRC_URI+=" https://github.com/alinxviso/overlay-files/releases/download/release/navidrome-0.63.2-deps.tar.xz -> ${P}-deps.tar.xz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3.0"
SLOT="0"
#IUSE=""

DEPEND="acct-user/navidrome
		"
RDEPEND="${DEPEND}
media-video/ffmpeg"
BDEPEND="dev-lang/go
		>=net-libs/nodejs-24.1.0
		virtual/zlib
		"

# INST_DIR="/opt/navidrome"
if [[ "${PV}" == *9999* ]]; then
src_unpack() {
		git-r3_src_unpack
		go-module_live_vendor
}
fi

src_configure() {
	emake setup
}

src_compile() {
	emake build
}

src_install() {
	dodir /opt/navidrome
	fowners navidrome:navidrome /opt/navidrome
	exeinto /opt/navidrome
	doexe navidrome
	dodir /etc/navidrome
	insinto /etc/navidrome
	doins release/linux/navidrome.toml
	dosym /etc/navidrome/navidrome.toml /opt/navidrome/navidrome.toml
	keepdir /var/lib/navidrome
	fowners -R navidrome:navidrome /var/lib/navidrome
	doinitd contrib/navidrome
	systemd_dounit contrib/navidrome.service
}
