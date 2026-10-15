# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Dependencies taken from https://archlinux.org/packages/extra/x86_64/lightdm-slick-greeter
# Dependencies taken from https://github.com/linuxmint/slick-greeter/blob/master/meson.build

EAPI=8

VALA_MIN_API_VERSION="0.34"
VALA_USE_DEPEND="vapigen"

inherit gnome2-utils vala meson

DESCRIPTION="A slick-looking LightDM greeter"
HOMEPAGE="https://github.com/linuxmint/slick-greeter"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="${HOMEPAGE}"
	KEYWORDS=""
else
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN//lightdm-}-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	x11-misc/lightdm[introspection,vala]
	sys-devel/gettext
"
#	>=dev-util/intltool-0.35.0
RDEPEND="${DEPEND}
	x11-libs/cairo
	media-libs/freetype
	>=x11-libs/gtk+-3.20:3
	media-libs/libcanberra
	x11-libs/libXext
	x11-libs/pixman
"
BDEPEND="
	$(vala_depend)
	dev-build/meson
"

src_prepare(){
	default_src_prepare
	export VALAC="$(type -P valac-$(vala_best_api_version))"
}

src_configure(){
	meson_src_configure
}

src_install(){
	default_src_install
	insinto /etc/lightdm
	doins "${FILESDIR}/${PN//lightdm-}.conf"
}

pkg_preinst(){
	gnome2_schemas_savelist
}

pkg_postinst(){
	gnome2_schemas_update
	einfo "To enable the slick-greeter support, set the greeter-session option"
	einfo "to 'slick-greeter' in your lightdm.conf in order to get this:"
	einfo "greeter-session=slick-greeter"
	einfo "then, restart your session and the lightdm/xdm daemon."
}

pkg_postrm(){
	gnome2_schemas_update
}
