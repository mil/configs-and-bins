#!/usr/bin/ruby
require "socket"
require "redcarpet"

def generatePage(filePath)
	#Read style file
	style = File.read("/home/mil/.config/markview/style.css")

	#Use Redcarpet to convert Markdown->HTML
	redcarpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
	markdown = redcarpet.render(File.read(filePath))

	#The Content Header Well Be Serving
	header = "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"

	#The Content We'll Be Serving
	content = %(
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Markview : #{filePath}</title>
		<style type="text/css">#{style}</style>
	</head>
	<body>#{markdown}</body>
	)
	return header, content
end

#Start it Up
server = TCPServer.new('localhost', 2000)
loop do
	header, content = generatePage("#{Dir.getwd}/#{ARGV[0]}")
	Thread.start(server.accept) do |session|
		session.print(header)
		session.print(content)
		session.close
	end
end
