####################################################################################
# ifetch-tools is a set of tools that can collect images from ip based cameras,
# monitor collection process, and provide an interface to view collected history.
# Copyright (C) 2005-2021 Richard Nelson
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


####################################################################################
# Notes for README.txt
####################################################################################
# - As of ifetch-tools-0.15.0 you need to install via the .deb and start and stop
#   from /etc/init.d/ifetch-tools
# - ifetch-tools will not start until you edit the /etc/ifetch-tools/ifetch-tools.conf
# - Please read the available options in the /etc/ifetch-tools/ifetch-tools.conf file.

To access a camera history once configured try something like the following URL:

http://localhost:2000/camera?cameraName=camera#

where exampleCamera would be the ending dir name in the htdocs directory.

To check the status of your cameras try something like the following URL:

http://localhost:2000/monitor

