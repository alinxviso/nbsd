# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://aur.archlinux.org/packages/plank-reloaded-git

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A lightweight, customizable Linux dock with modern docklets and GTK support."
HOMEPAGE="https://github.com/zquestz/plank-reloaded"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
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

#src_unpack() {
#}
## Uses default src_unpack for tar.gz

src_configure() {
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
	"${ROOT}"/usr/bin/glib-compile-schemas '"${ROOT}"/usr/share/glib-2.0/schemas'
	"${ROOT}"/usr/bin/gtk-update-icon-cache -q -t -f '"${ROOT}"/usr/share/icons/hicolor'
	"${ROOT}"/usr/bin/update-desktop-database -q '"${ROOT}"/usr/share/applications'
	xdg_icon_cache_update
}
pkg_postrm() {
	"${ROOT}"/usr/bin/glib-compile-schemas '"${ROOT}"/usr/share/glib-2.0/schemas'
	"${ROOT}"/usr/bin/gtk-update-icon-cache -q -t -f '"${ROOT}"/usr/share/icons/hicolor'
	"${ROOT}"/usr/bin/update-desktop-database -q '"${ROOT}"/usr/share/applications'
	xdg_icon_cache_update
}
