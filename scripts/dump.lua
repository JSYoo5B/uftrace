-- uftrace-option: --auto-args --nest-libcall
-- UFTRACE_FUNCS = [ "foo", "bar" ]

function uftrace_begin(ctx)
    print('uftrace_begin(ctx)')
    print(string.format('  record  : %s', ctx['record']))
    print(string.format('  version : %s', ctx['version']))
    if ctx['cmds'] ~= nil then
        print(string.format('  cmds    : %s', table.concat(ctx['cmds'], ' ')))
    end
    print('')
end

function uftrace_entry(ctx)
    local _tid        = ctx['tid']
    local _depth      = ctx['depth']
    local _time       = ctx['timestamp']
    -- _duration = ctx["duration"]        -- exit only
    local _address    = ctx['address']
    local _name       = ctx['name']

    local unit = 1000000000
    print(string.format('%d.%09d %6d: [entry] %s(%x) depth: %d',
            _time / unit, _time % unit, _tid, _name, _address, _depth))

    if ctx['args'] ~= nil then
        for i, arg in ipairs(ctx['args']) do
            print(string.format('  args[%d] %s: %s', i, type(arg), arg))
        end
    end
end

function uftrace_exit(ctx)
    local _tid        = ctx['tid']
    local _depth      = ctx['depth']
    local _time       = ctx['timestamp']
    local _duration   = ctx["duration"]        -- not used here
    local _address    = ctx["address"]
    local _name       = ctx["name"]

    local unit = 1000000000
    print(string.format('%d.%09d %6d: [exit ] %s(%x) depth: %d',
            _time / unit, _time % unit, _tid, _name, _address, _depth))

    if ctx['retval'] ~= nil then
        local ret = ctx['retval']
        print(string.format('  retval  %s: %s', type(ret), ret))
    end
end

function uftrace_event(ctx)
    local _tid        = ctx['tid']
    local _time       = ctx['timestamp']
    local _address    = ctx["address"]
    local _name       = ctx["name"]

    local unit = 1000000000
    print(string.format('%d.%09d %6d: [event] %s(%x)',
            _time / unit, _time % unit, _tid, _name, _address))
end

function uftrace_end()
    print('\nuftrace_end()')
end
