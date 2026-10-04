ruleset { dynamic_casting };

m :: Map = map();
m.set("a", 1);
m.set("b", 2);
m.set("c", 3);

# has: presence
if !m.has("a") { out("FAIL: m.has(\"a\") false"); exit(1); }
if m.has("z") { out("FAIL: m.has(\"z\") true"); exit(1); }

# get: value
if m.get("a") != 1 { out("FAIL: m.get(\"a\") = " + string(m.get("a"))); exit(1); }
if m.get("b") != 2 { out("FAIL: m.get(\"b\") = " + string(m.get("b"))); exit(1); }

# get: absent key -> null
missing = m.get("z");
if missing != null { out("FAIL: m.get(\"z\") != null"); exit(1); }

# get_or: present
if m.get_or("a", 99) != 1 { out("FAIL: get_or present"); exit(1); }

# get_or: absent -> default
if m.get_or("z", 99) != 99 { out("FAIL: get_or absent"); exit(1); }

# is_empty
e :: Map = map();
if !e.is_empty() { out("FAIL: empty map is_empty false"); exit(1); }
if m.is_empty() { out("FAIL: non-empty map is_empty true"); exit(1); }

# keys / values still work
ks = m.keys();
vs = m.values();
if ks.size() != 3 { out("FAIL: keys.size() = " + string(ks.size())); exit(1); }
if vs.size() != 3 { out("FAIL: values.size() = " + string(vs.size())); exit(1); }

# delete still polymorphic
m.delete("a");
if m.has("a") { out("FAIL: delete did not remove"); exit(1); }
if m.keys().size() != 2 { out("FAIL: size after delete = " + string(m.keys().size())); exit(1); }

# clear
m.clear();
if !m.is_empty() { out("FAIL: clear did not empty"); exit(1); }

out("map_methods_test: PASS");