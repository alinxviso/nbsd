# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# see https://devmanual.gentoo.org/eclass-reference/meson.eclass/index.html as a resource to learn more about meson ebuilds
EAPI=8

inherit meson shell-completion

DESCRIPTION="A fast, simple, lightweight service manager/supervision system, which can also serve as /sbin/init"
HOMEPAGE="https://davmac.org/projects/dinit"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	PROPERTIES="live"
	EGIT_REPO_URI="https://github.com/davmac314/${PN}"
	KEYWORDS=""
else
	SRC_URI=${HOMEPAGE}
#	SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="Apache-2.0"
SLOT="0"
IUSE="+build-shutdown +cgroups clang fuzzer igr-tests +man unit-test"

DEPEND="
	one
"
RDEPEND="${DEPEND}"
BDEPEND="
		!clang? ( >=sys-devel/gcc-11* )
		clang? ( >=llvm-core/clang-7* )
		dev-build/make
"
# files to be saved in /usr/share/doc/${PN}-${PV}
DOCS=(CONTRIBUTORS LICENSE doc/)

if [[ "${PV}" == *9999* ]]; then
src_unpack() {
		git-r3_src_unpack
}
fi
## Else uses default src_unpack for tar.gz

src_configure() {
# configures meson features & options. see meson_options.txt or similar to see what to do and where.
local emesonargs=(
	$(meson_feature build-shutdown)
	$(meson_feature cgroups support-cgroups)
	$(meson_use fuzzer)
	$(meson_use man man-pages)
	$(meson_use igr-tests)
)
# args that are mandatory, set by ebuild
MYMESONARGS="-Dshutdown-prefix=dinit-"
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


if [[ use shell-completion  ]]
pkg_postinst() {
	cp contrib/shell-completion/fish/dinitctl.fish /usr/share/fish/vendor_completions.d/
}

pkg_postrm() {

}
