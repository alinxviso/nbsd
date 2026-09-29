# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://aur.archlinux.org/packages/plank-reloaded-git

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A lightweight, customizable Linux dock with modern docklets and GTK support."
HOMEPAGE="https://github.com/zquestz/plank-reloaded"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="https://github.com/zquestz/${PN}"
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3.0"
SLOT="0"
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

if [[ "${PV}" == *9999* ]]; then
src_unpack() {
		git-r3_src_unpack
}
fi
## Else uses default src_unpack for tar.gz

src_configure() {
if [[ "${PV}" != 9999 ]]; then
	MYMESONARGs="-Dproduction-release=true"
fi
#meson setup --prefix="/usr" build 
	meson_src_configure
}

src_compile() {
	meson_src_compile
#	meson compile -C build
}

src_install() {
	meson_src_install
#	meson install -C build 
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
