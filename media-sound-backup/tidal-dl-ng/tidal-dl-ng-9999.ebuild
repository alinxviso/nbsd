# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://aur.archlinux.org/packages/tidal-dl-ng

EAPI=8

inherit xdg-utils

DESCRIPTION="Multithreaded TIDAL Media Downloader Next Generation!"
HOMEPAGE="https://github.com/exislow/tidal-dl-ng"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="https://github.com/exislow/${PN}"
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3.0"
SLOT="0"
#IUSE="at-spi2-atk"

DEPEND="
#		at-spi2-atk? ( app-accessibility/at-spi2-atk )
#		!at-spi2-atk? ( dev-libs/atk )
		dev-lang/python
		dev-python/ansi2html
		dev-python/coloredlogs
		dev-python/darkdetect
		dev-python/dataclasses-json
		dev-python/pathvalidate
		dev-python/pycryptodome
		dev-python/pyqtdarktheme
		>=dev-python-pyside-6.0.0
		dev-python/requests
		dev-python/rich
		dev-python/typer
		media-libs/mutagen
		"
RDEPEND="${DEPEND}"
BDEPEND="
		dev-python/build
		dev-python/installer
		dev-python/poetry-core
		"
if [[ "${PV}" == 9999 ]]; then
	BDEPEND="${BDEPEND}
		dev-vcs/git
"
fi

if [[ "${PV}" == *9999* ]]; then
src_unpack() {
		git-r3_src_unpack
}
fi

src_configure() {
}

src_compile() {
}

src_install() {
}

pkg_postinst() {
	/usr/bin/glib-compile-schemas '/usr/share/glib-2.0/schemas'
	/usr/bin/gtk-update-icon-cache -q -t -f '/usr/share/icons/hicolor'
	/usr/bin/update-desktop-database -q '/usr/share/applications'
	xdg_icon_cache_update
}
pkg_postrm() {
	/usr/bin/glib-compile-schemas '/usr/share/glib-2.0/schemas'
	/usr/bin/gtk-update-icon-cache -q -t -f '/usr/share/icons/hicolor'
	/usr/bin/update-desktop-database -q '/usr/share/applications'
	xdg_icon_cache_update
}
