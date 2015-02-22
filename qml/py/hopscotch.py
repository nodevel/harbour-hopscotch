#!/usr/bin/python
#
# This file is part of Hopscotch
#
# Copyright(c) 2015 Jakub Kozisek aka nodevel
# <nodevel at gmail dot com>
#
# This file may be licensed under the terms of of the
# GNU General Public License Version 2 (the ``GPL'').
#
# Software distributed under the License is distributed
# on an ``AS IS'' basis, WITHOUT WARRANTY OF ANY KIND, either
# express or implied. See the GPL for the specific language
# governing rights and limitations.
#
# You should have received a copy of the GPL along with this
# program. If not, go to http://www.gnu.org/licenses/gpl.html
# or write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
from Market import Market
from OperatorModel import Operator
from AssetRequest import AssetRequest
from Util import Util


def download(package, email, password, operator, device, path='/tmp', devname='passion', sdklevel=19):
    try:
        if not package:
            raise ValueError('No package')
        market = Market(email, password)
        market.login()
        operator = Operator(country, operator)
        request  = AssetRequest(package, market.token, device, operator, devname, sdklevel)
        (url, market_da)    = market.get_asset( request.encode() )
        Util.download_apk(package, url, market_da, path)
        return True
    except:
        return False