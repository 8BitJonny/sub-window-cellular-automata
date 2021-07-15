function varargout = loadRules(rules_path)
	if(ischar(rules_path))
		rules_path = {rules_path};
	endif
	varargout = {};
	rule_kind_look_up = struct("C", "CountBased", "P", "PatternBased");
	for i = 1:length(rules_path)
		[rule_kind_short, name] = strsplit(rules_path{i}, "/"){:};
		rule_kind = rule_kind_look_up.(rule_kind_short);
		varargout{end+1} = load(["./RuleSets/" rule_kind "/" name ".mat"]).("rule");
	end
endfunction
