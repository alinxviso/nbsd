# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{13..15} )

inherit distutils-r1

DESCRIPTION=".scrobbler.log (Rockbox offline last.fm scrobling format) submiter."
HOMEPAGE="https://github.com/ultraelephant/pyapplier"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"

DEPEND="dev-python/pylast[${PYTHON_USEDEP}]
		dev-python/pyaml[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( README.md  )

src_prepare() {
	default

	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["setuptools>=61.0.0"]
		build-backend = "setuptools.build_meta"

		[project]
		name = "pyapplier"
		version = "${PV}"
		dependencies = [
			"pylast",
			"pyaml"
		]

		[project.scripts]
		pyapplier = "pyapplier:main"
	EOF
}
