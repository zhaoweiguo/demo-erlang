DIALYZER = dialyzer
REBAR = ./rebar3
MAKE = make

all:app

app: deps
	@$(REBAR) compile

deps:
	@$(REBAR) get-deps

cdeps:
	@$(MAKE) -C _build/default/lib/merl/

upgrade: clean_rebar
	@$(REBAR) upgrade

clean:
	@$(REBAR) clean
	rm -f rebar3.crashdump

clean_rebar:
	rm -f rebar.lock

clean_all:
	rm -rf _build
	rm -f rebar.lock

