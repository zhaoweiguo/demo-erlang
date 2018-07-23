DIALYZER = dialyzer
REBAR = ./rebar3
MAKE = make

all:app

app: deps
	@$(REBAR) compile

rel: deps
	@$(REBAR) as prod release
	@$(REBAR) as prod tar

deps:
	@$(REBAR) get-deps

cdeps:
	@$(MAKE) -C _build/default/lib/merl/

upgrade:
	@$(REBAR) upgrade

clean:
	@$(REBAR) clean
	rm -f rebar3.crashdump

clean_rebar:
	rm -f rebar.lock

clean_all:
	rm -rf _build
	rm -f rebar.lock

