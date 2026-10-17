# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit shell-completion flag-o-matic

DESCRIPTION="Service monitoring/\"init\" system"
HOMEPAGE="https://davmac.org/projects/dinit"
SRC_URI="https://github.com/davmac314/dinit/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+bash-completion +capabilities +cgroups fish-completion +initgroups +ioprio +oom-adj +shutdown +utmpx zsh-completion"

DEPEND="
	capabilities? ( sys-libs/libcap )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/pkgconf
	|| ( >=sys-devel/gcc-11.0.0 >=llvm-core/clang-7.0 )
	sys-devel/m4
	ioprio? ( sys-kernel/linux-headers )
"
# files to be saved in /usr/share/doc/${P}
DOCS=(BUILD CONTRIBUTORS LICENSE NEWS README.md TODO doc/CODE-STYLE doc/COMPARISON doc/DESIGN doc/getting_started.md \
doc/SECURITY doc/linux/DINIT-AS-INIT.md)

src_configure() {
	append-cxxflags -std=c++17
	local useconf

	if has nostrip "${FEATURES}" ; then
		useconf+=" --disable-strip"
	fi

	econf \
	--shutdown-prefix="dinit-" \
	$(use_enable shutdown) \
	$(use_enable cgroups) \
	$(use_enable capabilities) \
	$(use_enable ioprio) \
	$(use_enable oom-adj) \
	$(use_enable utmpx) \
	$(use_enable initgroups) \
	"${useconf}"
}

src_install() {
	if use fish-completion;then dofishcomp contrib/shell-completion/fish/dinitctl.fish; fi
	if use zsh-completion;then dozshcomp  contrib/shell-completion/zsh/_dinit; fi
	if use bash-completion;then dobashcomp contrib/shell-completion/bash/dinitctl; fi
	default_src_install
	insinto /etc/dinit.d
	doinst doc/linux/services
}

pkg_postinst() {
#	elog "If you want to use ${PN} as init you have 3 choices:"
#	elog "- Change the kernel command line in your bootloader"
#	elog "- Change the kernel command line in /etc/kernel/cmdline (if applicable)"
#	elog "- Manually create a symlink from /sbin/dinit to /sbin/init"
	elog "A \"getting started\" file has been installed into"
	elog "/usr/share/doc/${P}/getting_started.md.bz2"
	elog "If you want to use ${PN} as init, you may want to check"
	elog "/usr/share/doc/${P}/DINIT-AS_INIT.md.bz2"
}

pkg_prerm() {
	if [[ $(< /proc/1/comm ) == *"dinit"* ]];then
		die "PID 1 appears to be dinit. Please do not uninstall it while it is init."
	fi
}

pkg_postrm() {
	ewarn "Please ensure that ${PN} is not still set as the default init to ensure a"
	ewarn "bootable system."
}
