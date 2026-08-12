# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION=".scrobbler.log (Rockbox offline last.fm scrobling format) submiter."
HOMEPAGE="https://github.com/ultraelephant/pyapplier"
SRC_URI="${HOMEPAGE}/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

DEPEND="dev-python/pylast
		dev-python/pyaml"
RDEPEND="${DEPEND}"
BDEPEND="dev-python/setuptools"
