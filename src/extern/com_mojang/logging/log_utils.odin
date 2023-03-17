package com_mojang_logging
import "core:fmt"
import "core:strings"

import "mco:odin/global"

/*
public class LogUtils {
    public static final String FATAL_MARKER_ID = "FATAL";
    public static final Marker FATAL_MARKER = MarkerFactory.getMarker(FATAL_MARKER_ID);
    private static final StackWalker STACK_WALKER = StackWalker.getInstance(StackWalker.Option.RETAIN_CLASS_REFERENCE);

    public static boolean isLoggerActive() {
        final LoggerContext loggerContext = LogManager.getContext();
        if (loggerContext instanceof LifeCycle lifeCycle) {
            return !lifeCycle.isStopped();
        }
        return true; // Sensible default? In worst case, no logs - so not a huge loss
    }

    public static void configureRootLoggingLevel(final org.slf4j.event.Level level) {
        final org.apache.logging.log4j.core.LoggerContext ctx = (org.apache.logging.log4j.core.LoggerContext) LogManager.getContext(false);
        final Configuration config = ctx.getConfiguration();
        final LoggerConfig loggerConfig = config.getLoggerConfig(LogManager.ROOT_LOGGER_NAME);
        loggerConfig.setLevel(convertLevel(level));
        ctx.updateLoggers();
    }

    private static Level convertLevel(final org.slf4j.event.Level level) {
        return switch (level) {
            case INFO -> Level.INFO;
            case WARN -> Level.WARN;
            case DEBUG -> Level.DEBUG;
            case ERROR -> Level.ERROR;
            case TRACE -> Level.TRACE;
        };
    }

    public static Object defer(final Supplier<Object> result) {
        class ToString {
            @Override
            public String toString() {
                return result.get().toString();
            }
        }

        return new ToString();
    }

    /**
     * Caller sensitive, DO NOT WRAP
     */
    public static Logger getLogger() {
        return LoggerFactory.getLogger(STACK_WALKER.getCallerClass());
    }
}
*/

Logger :: struct
{

}

LogLevel :: enum
{
    Info,
    Warn,
    Debug,
    Error,
    Fatal,
}

// (atm this doesn't actually do anything, hence empty struct)
g_logger := Logger{}

log :: proc(level: LogLevel, msg: string, ex: ^global.Exception = nil, loc := #caller_location)
{
	if ex != nil { fmt.println(level, msg, loc, ex) } else { fmt.println(level, msg, loc) }
    // TODO: add buffer + eventual file out possibly
}

/*Logger_info :: #force_inline proc(msg: string, ex: ^global.Exception)
{
    log("LOGGER INFO: ", msg, ex)
}

Logger_warn :: #force_inline proc(msg: string, ex: ^global.Exception)
{
	log("LOGGER WARNING: ", msg, ex)
}

Logger_error :: #force_inline proc(msg: string, ex: ^global.Exception)
{
	log("LOGGER ERROR: ", msg, ex)
}*/