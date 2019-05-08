%%%-------------------------------------------------------------------
%%% Copyright (c) 2019, sFractal Consulting, LLC

%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at

%%%     http://www.apache.org/licenses/LICENSE-2.0

%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.

%%%-------------------------------------------------------------------

%%%-------------------------------------------------------------------
%% @doc test env server
%% @end
%%%-------------------------------------------------------------------

-module(env_SUITE).
-author("Duncan Sparrell").
-copyright("2019, sFractal Consulting, LLC").
-license(apache2).

%% for test export all functions
-export( [ all/0
         , suite/0
         , init_per_suite/1
         , end_per_suite/1
         , test_sim_query/1
         , test_sim_restart/1
         ] ).

%% required for common_test to work
-include_lib("common_test/include/ct.hrl").

%% tests to run
all() ->
    [ test_sim_query      %% test query command to simulator
    , test_sim_restart    %% test restart command to simulator
                          %% add actuator and orchestrator tests later
    ].

%% timeout if no reply in a minute
suite() ->
    [{timetrap, {minutes, 2}}].

%% setup config parameters
init_per_suite(Config) ->
    {ok, _AppList} = application:ensure_all_started(lager),

    {ok, _AppList2} = application:ensure_all_started(shotgun),

    %% since ct doesn't read sys.config, set configs here
    application:set_env(ocas, port, 8080),
    application:set_env(ocas, listener_count, 5),

    %% start application
    {ok, _AppList3} = application:ensure_all_started(ocas),

    Config.

end_per_suite(Config) ->
    Config.

test_sim_query(Config) ->
    %% send sim_query01.json and get sim_query01.results.json
    helper_json:post_sim( "sim_query01.json"
                        , "sim_query01.results.json"
                        , Config
                        ),
    ok.

test_sim_restart(Config) ->
  %% send sim_query01.json and get sim_query01.results.json
  helper_json:post_sim( "sim_restart01.json"
                      , "sim_restart01.results.json"
                      , Config
                      ),
  ok.
