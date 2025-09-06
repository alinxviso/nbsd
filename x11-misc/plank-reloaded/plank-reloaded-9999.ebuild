# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://aur.archlinux.org/packages/plank-reloaded-git

EAPI=8

inherit meson

DESCRIPTION="A lightweight, customizable Linux dock with modern docklets and GTK support."
HOMEPAGE="https://github.com/zquestz/plank-reloaded"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="https://github.com/zquestz/${PN}"
else
	SRC_URI="https://github.com/zquestz/${PN}/archive/refs/tags/${PV}.tar.gz" -> ${P}.tar.gz
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3.0"
SLOT="0"
KEYWORDS=""
IUSE="at-spi2-atk"

DEPEND="
		at-spi2-atk? ( app-accessibility/at-spi2-atk )
		!at-spi2-atk? ( dev-libs/atk )
		dev-libs/glib
		dev-libs/libdbusmenu
		dev-libs/libgee
		gnome-base/gnome-menus
		sys-libs/glibc
		x11-libs/cairo
		>=x11-libs/gdk-pixbuf-2.0.1
		>=x11-libs/gtk+-3.0.1
		>=x11-libs/libwnck-31.0.1
		x11-libs/bamf
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/pango
		"
RDEPEND="${DEPEND}"
BDEPEND="
		dev-build/meson
		dev-build/ninja
		dev-lang/vala
		dev-util/intltool
		dev-vcs/git
		gnome-base/gnome-common
		"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
	fi
}

src_configure() {
#meson setup --prefix="/usr" build || die "meson setup failed with \"meson setup --prefix='/usr' build\""
	meson_src_configure || die "meson setup failed"
}

src_compile() {
	meson_src_compile || die "meson compile failed"
#	meson compile -C build || die "compile failed with \"meson compile -C build\""
}

src_install() {
	meson_src_install
#	meson install -C build || die "error installing with \"meson install -C build\""
}
