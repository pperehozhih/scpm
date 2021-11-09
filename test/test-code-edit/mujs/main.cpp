#include <stdio.h>
#include "mujs.h"

static void print(js_State* J)
{
	const char* name = js_tostring(J, 1);
	printf("%s!\n", name);
	js_pushundefined(J);
}

void _js_Panic(js_State* J) {

}

int main(int argc, char** argv)
{
	char line[256];
	js_State* J = js_newstate(NULL, NULL, JS_STRICT);
	js_newcfunction(J, print, "print", 1);
	js_setglobal(J, "print");
	auto old = js_atpanic(J, _js_Panic);
	while (fgets(line, sizeof line, stdin))
		js_dostring(J, line);
	js_freestate(J);
}
