local p = premake
local m = { }

-- Properties
local props = function()
	return {
		m.name,
		m.kind,
		m.files,
		m.includedirs,
		m.librarydirs,
		m.defines,
		m.libraries,
	}
end

-- Generate project
function p.extensions.geno.generateproject( prj )
	p.indent( "\t" )
	p.callArray( props, prj )
end

-- Name
function m.name( prj )
	p.w( "Name:%s", prj.name )
end

-- Kind
function m.kind( prj )
	local map = {
		WindowedApp = "Application",
		ConsoleApp  = "Application",
		StaticLib   = "StaticLibrary",
		SharedLib   = "DynamicLibrary",
	}
	p.w( "Kind:%s", map[ prj.kind ] )
end

-- Files
function m.files( prj )
	if( #prj.files > 0 ) then
		p.push "Files:"
		for _, file in ipairs( prj.files ) do
			local relativepath = path.getrelative( prj.location, file )
			p.w( "%s", relativepath )
		end
		p.pop()
	end
end

-- IncludeDirs
function m.includedirs( prj )
	if( #prj.includedirs > 0 or #prj.sysincludedirs > 0 ) then
		p.push "IncludeDirs:"
		for _, dir in ipairs( prj.includedirs ) do
			local relativepath = path.getrelative( prj.location, dir )
			p.w( "%s", relativepath )
		end
		for _, dir in ipairs( prj.sysincludedirs ) do
			local relativepath = path.getrelative( prj.location, dir )
			p.w( "%s", relativepath )
		end
		p.pop()
	end
end

-- LibraryDirs
function m.librarydirs( prj )
	local dependencies = p.project.getdependencies( prj, "linkOnly" )
	if( #dependencies > 0 ) then
		p.push "LibraryDirs:"
		for _, dep in ipairs( dependencies ) do
			local relativepath = path.getrelative( prj.location, dep.location )
			p.w( "%s", relativepath )
		end
		p.pop()
	end
end

-- Defines
function m.defines( prj )
	if( #prj.defines > 0 ) then
		p.push "Defines:"
		for _, define in ipairs( prj.defines ) do
			p.w( "%s", define )
		end
		p.pop()
	end
end

-- Libraries
function m.libraries( prj )
	if( #prj.links > 0 ) then
		p.push "Libraries:"
		for _, link in ipairs( prj.links ) do
			p.w( "%s", link )
		end
		p.pop()
	end
end
