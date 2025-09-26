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
	SRC_URI="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="Apache-2.0"
SLOT="0"
IUSE="+build-shutdown +cgroups fuzzer igr-tests +man unit-test"

#DEPEND=
RDEPEND="${DEPEND}"
BDEPEND="
		>=sys-devel/gcc-11.0.0
		dev-build/make
"
# files to be saved in /usr/share/doc/${PN}-${PV}
DOCS=(CONTRIBUTORS LICENSE doc/CODE-STYLE doc/DESIGN doc/SECURITY doc/getting_started.md doc/linux/DINIT-AS-INIT.md)

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
#	meson compile -C build
	meson_src_compile
}

src_install() {
#	meson install -C build 
	meson_src_install
	dofishcomp contrib/shell-completion/fish/dinitctl.fish
	dozshcomp  contrib/shell-completion/zsh/_dinit
	dobashcomp contrib/shell-completion/bash/dinitctl
#	cp contrib/shell-completion/fish/dinitctl.fish /usr/share/fish/vendor_completions.d/ yadayadayada
}


pkg_postinst() {
	eqawarn "If you want to use ${PV} as init you have 3 choices:"
	eqawarn "change kernel command line in your bootloader"
	eqawarn "change kernel command line in /etc/kernel/cmdline (if applicable)"
	eqawarn "manually create a symlink from /sbin/dinit to /sbin/init"
	einfo  "A \"getting started\" file has been installed into /usr/doc/${PN-${PV}}"
}

pkg_postrm() {
	eqawarn "Please ensure that ${PV} is no longer set as init if"
	eqawarn "it was before to ensure a bootable system."
}
