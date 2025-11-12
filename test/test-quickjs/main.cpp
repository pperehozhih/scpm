#include <quickjs/quickjs.h>

static JSValue js_print(JSContext *ctx, JSValueConst this_val,
                        int argc, JSValueConst *argv) {
    for (int i = 0; i < argc; i++) {
        const char *str = JS_ToCString(ctx, argv[i]);
        if (!str) {
            return JS_EXCEPTION;
        }
        printf("%s", str);
        JS_FreeCString(ctx, str);
        if (i != argc - 1) {
            printf(" ");
        }
    }
    printf("\n");
    return JS_UNDEFINED;
}

int main() {
    auto rt = JS_NewRuntime();
    auto ctx = JS_NewContext(rt);
    const char *js_code = "let a = 2; let b = 4; a * b;";
    JSValue print = JS_NewCFunction(ctx, js_print, "print", 1);
    JSValue global_obj = JS_GetGlobalObject(ctx);
    JS_SetPropertyStr(ctx, global_obj, "print", print);
    JS_FreeValue(ctx, global_obj);
    auto res = JS_Eval(ctx, js_code, strlen(js_code), "<mem>", JS_EVAL_TYPE_GLOBAL);
    if (JS_IsException(res)) {
        JSValue exception = JS_GetException(ctx);
        const char *error = JS_ToCString(ctx, exception);
        fprintf(stderr, "JavaScript exception: %s\n", error);
        JS_FreeCString(ctx, error);
        JS_FreeValue(ctx, exception);
    } else {
        int32_t int_result;
        if (JS_ToInt32(ctx, &int_result, res) == 0) {
            printf("Result: %d\n", int_result);
        } else {
            // Convert to string instead
            const char *str_result = JS_ToCString(ctx, res);
            if (str_result) {
                printf("Result: %s\n", str_result);
                JS_FreeCString(ctx, str_result);
            } else {
                printf("Failed to convert result to string\n");
            }
        }
        JS_FreeValue(ctx, res);
    }
    const char *script = "print('Hello,', 'World!');";
    res = JS_Eval(ctx, script, strlen(script), "<input>", JS_EVAL_TYPE_GLOBAL);
    if (JS_IsException(res)) {
        JSValue exception = JS_GetException(ctx);
        const char *error = JS_ToCString(ctx, exception);
        fprintf(stderr, "JavaScript exception: %s\n", error);
        JS_FreeCString(ctx, error);
        JS_FreeValue(ctx, exception);
    }
    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);
    return 0;
}
