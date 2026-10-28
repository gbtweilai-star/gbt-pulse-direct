# pulse_direct

**One capability bit from GBT V8, packaged standalone.** No. 317 of 341,
`tools` domain (Tools).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> **脉冲直达**（主人令 2026-10-11「把脉冲给大模型，让她把所有的能力按触手双向绑定的部署方式**急速运行**、**省去不必要的多绕** —— 本来向前跨一步就到的东西，别跑一大圈才跨那一步」）：一句意图 => **一步**解析到能力位 => 给出那一条命令与要过的门，并把 **hops（绕弯数）写进账**：hops=1 直接命中 / hops=2 命中页面包装层（该收敛）/ hops=0 没命中（如实报，不编）。op=audit 读回**一步命中率** => 「省多绕」变成可量的事。三根支柱现读：能力位册 / 双向绑定(cap-bindings+page-caps) / 唯一门 run_task。与既有 tools/pulse.py（每日情报调研执行层）不是一件东西，不覆盖不合并。op=resolve/audit

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-pulse-direct.git
cd gbt-pulse-direct
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_pulse_direct info                  # capability card
python -m gbt_pulse_direct spec --json           # machine-readable contract
python -m gbt_pulse_direct check --payload '{}'
python -m gbt_pulse_direct run   --payload '{}'
```

Real `info` output from this machine:

```text
pulse_direct  (tools)  v1.0.0
----------------------------------------
**脉冲直达**（主人令 2026-10-11「把脉冲给大模型，让她把所有的能力按触手双向绑定的部署方式**急速运行**、**省去不必要的多绕** —— 本来向前跨一步就到的东西，别跑一大圈才跨那一步」）：一句意图 => **一步**解析到能力位 => 给出那一条命令与要过的门，并把 **hops（绕弯数）写进账**：hops=1 直接命中 / hops=2 命中页面包装层（该收敛）/ hops=0 没命中（如实报，不编）。op=audit 读回**一步命中率** => 「省多绕」变成可量的事。三根支柱现读：能力位册 / 双向绑定(cap-bindings+page-caps) / 唯一门 run_task。与既有 tools/pulse.py（每日情报调研执行层）不是一件东西，不覆盖不合并。op=resolve/audit

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : (multi-op, but the registry does not enumerate them)
```

Wire a real implementation:

```python
from gbt_pulse_direct import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表标注 `multi_op: true`，但没有枚举具体取值。**本包不替它编造取值清单——这种缺口应当在注册表源头补，而不是在文档里圆。

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `pulse_direct` |
| domain | `tools` |
| handler | `pulse_direct` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [tools/pulse_direct](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/tools/pulse_direct.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
