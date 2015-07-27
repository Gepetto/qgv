# - Try to find Graphviz cgraph library
# Once done this will define
#
#  GRAPHVIZ_FOUND - system has Graphviz installed
#  GRAPHVIZ_INCLUDE_DIR
#  GRAPHVIZ_GVC_LIBRARY
#  GRAPHVIZ_CGRAPH_LIBRARY
#  GRAPHVIZ_CDT_LIBRARY
#
#

if ( GRAPHVIZ_CGRAPH_LIBRARY )
   # in cache already
   SET(Graphviz_FIND_QUIETLY TRUE)
endif ( GRAPHVIZ_CGRAPH_LIBRARY )

# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
if( NOT WIN32 )
  find_package(PkgConfig)

  pkg_check_modules(GRAPHVIZ_GVC_PKG gvc)
  pkg_check_modules(GRAPHVIZ_CGRAPH_PKG cgraph)
  pkg_check_modules(GRAPHVIZ_CDT_PKG cdt)
endif( NOT WIN32 )

FIND_LIBRARY(GRAPHVIZ_GVC_LIBRARY NAMES gvc libgvc
  PATHS
    /usr/lib
    /usr/local/lib
  HINTS
    ${GRAPHVIZ_GVC_PKG_LIBRARY_DIRS} # Generated by pkg-config
)
IF ( NOT(GRAPHVIZ_GVC_LIBRARY) )
  MESSAGE(STATUS "Could not find libgvc." )
  SET(GRAPHVIZ_GVC_FOUND FALSE)
ELSE ()
  SET(GRAPHVIZ_GVC_FOUND TRUE)
ENDIF ()

FIND_LIBRARY(GRAPHVIZ_CGRAPH_LIBRARY NAMES cgraph libcgraph
  PATHS
    /usr/lib
    /usr/local/lib
  HINTS
    ${GRAPHVIZ_CGRAPH_PKG_LIBRARY_DIRS} # Generated by pkg-config
)
IF ( NOT(GRAPHVIZ_CGRAPH_LIBRARY) )
  MESSAGE(STATUS "Could not find libcgraph." )
  SET(GRAPHVIZ_CGRAPH_FOUND FALSE)
ELSE ()
  SET(GRAPHVIZ_CGRAPH_FOUND TRUE)
ENDIF ()

FIND_LIBRARY(GRAPHVIZ_CDT_LIBRARY NAMES cdt libcdt
  PATHS
    /usr/lib
    /usr/local/lib
  HINTS
    ${GRAPHVIZ_CDT_PKG_LIBRARY_DIRS} # Generated by pkg-config
)
IF ( NOT(GRAPHVIZ_CDT_LIBRARY) )
  MESSAGE(STATUS "Could not find libcdt." )
  SET(GRAPHVIZ_CDT_FOUND FALSE)
ELSE ()
  SET(GRAPHVIZ_CDT_FOUND TRUE)
ENDIF ()

FIND_PATH(GRAPHVIZ_INCLUDE_DIR NAMES cgraph.h
  PATHS
    /usr/include/graphviz
    /usr/local/include/graphviz
  HINTS
    ${GRAPHVIZ_PKG_INCLUDE_DIR} # Generated by pkg-config
)
IF ( NOT(GRAPHVIZ_INCLUDE_DIR) )
  MESSAGE(STATUS "Could not find graphviz headers." )
ENDIF ()

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Graphviz_Gvc DEFAULT_MSG GRAPHVIZ_GVC_LIBRARY )
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Graphviz_Cgraph DEFAULT_MSG GRAPHVIZ_CGRAPH_LIBRARY )
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Graphviz_Cdt DEFAULT_MSG GRAPHVIZ_CDT_LIBRARY )
FIND_PACKAGE_HANDLE_STANDARD_ARGS("Graphviz Headers" DEFAULT_MSG GRAPHVIZ_INCLUDE_DIR )


# show the POPPLER_(XPDF/QT4)_INCLUDE_DIR and POPPLER_LIBRARIES variables only in the advanced view
MARK_AS_ADVANCED(GRAPHVIZ_INCLUDE_DIR GRAPHVIZ_GVC_LIBRARY GRAPHVIZ_CGRAPH_LIBRARY GRAPHVIZ_CDT_LIBRARY)

