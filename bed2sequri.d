module bed2sequri;

import std.algorithm : splitter;
import std.conv : to;
import std.format;
import std.range : enumerate;
import std.stdio;
import std.string;

const string delim = "\t";

enum { sequri, link, html };

int main(string[] args) {

	string build;
	int mode;

	if (args.length < 2) {
		stderr.writeln("Please supply a genome build");
		return 1;
	}
	else if (args.length == 2) {
		build = args[1];
	}
	else if (args.length == 3) {
		if (args[1] == "-l" || args[1] == "--link") mode = link;
		else if (args[1] == "-h" || args[1] == "--html") mode = html;
		else {
			stderr.writeln("Unrecognized arguments. USAGE:\n\t-l\t--link\tProduce seqURIs linking through sequri.org\n\t-h\t--html\tProduce HTML <a> tags.");
			return 1;
		}
		build = args[2];
	}
	else {
		stderr.writeln("Unrecognized arguments. USAGE:\n\t-l\t--link\tProduce seqURIs linking through sequri.org\n\t-h\t--html\tProduce HTML <a> tags.");
		return 1;
	}

	string contig = "";
	long start;
	long end;

	auto range = stdin.byLine();
	foreach (line; range) {
		foreach (i, field; line.splitter(delim).enumerate)
		{
			if (i == 0) contig = field.to!string;
			else if (i == 1) start = field.to!long;
			else if (i == 2) end = field.to!long;
			else continue;
		}
		auto url = format("http://sequri.org/%s/%s:%d-%d", build, contig, start, end);
		auto sequri = format("seq:%s/%s:%d-%d", build, contig, start, end);
		if (mode == link) 	writeln( url );
		else if (mode == html) 	writefln("<a href=\"%s\">%s</a>", url, sequri);
		else 			writeln( sequri );
	}

	return 0;
}
