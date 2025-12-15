<cfcomponent>
	<cffunction name="maptable" access="public" returntype="string">
		<cfargument name="inputchar" type="string" required="yes">
        
		<cfswitch expression="#inputchar#">
        <cfcase value="0">
        <cfset myResult="0">
        </cfcase>
        <cfcase value="1">
        <cfset myResult="1">
        </cfcase>
        <cfcase value="2">
        <cfset myResult="2">
        </cfcase>
        <cfcase value="3">
        <cfset myResult="3">
        </cfcase>
        <cfcase value="4">
        <cfset myResult="4">
        </cfcase>
        <cfcase value="5">
        <cfset myResult="5">
        </cfcase>
        <cfcase value="6">
        <cfset myResult="6">
        </cfcase>
        <cfcase value="7">
        <cfset myResult="7">
        </cfcase>
        <cfcase value="8">
        <cfset myResult="8">
        </cfcase>
        <cfcase value="9">
        <cfset myResult="9">
        </cfcase>
        <cfcase value="a">
        <cfset myResult="11">
        </cfcase>
        <cfcase value="b">
        <cfset myResult="12">
        </cfcase>
        <cfcase value="c">
        <cfset myResult="13">
        </cfcase>
        <cfcase value="d">
        <cfset myResult="14">
        </cfcase>
        <cfcase value="e">
        <cfset myResult="15">
        </cfcase>
        <cfcase value="f">
        <cfset myResult="16">
        </cfcase>
        <cfcase value="g">
        <cfset myResult="17">
        </cfcase>
        <cfcase value="h">
        <cfset myResult="18">
        </cfcase>
        <cfcase value="i">
        <cfset myResult="19">
        </cfcase>
        <cfcase value="j">
        <cfset myResult="20">
        </cfcase>
        <cfcase value="k">
        <cfset myResult="21">
        </cfcase>
        <cfcase value="l">
        <cfset myResult="22">
        </cfcase>
        <cfcase value="m">
        <cfset myResult="23">
        </cfcase>
        <cfcase value="n">
        <cfset myResult="24">
        </cfcase>
        <cfcase value="o">
        <cfset myResult="25">
        </cfcase>
        <cfcase value="p">
        <cfset myResult="26">
        </cfcase>
        <cfcase value="q">
        <cfset myResult="27">
        </cfcase>
        <cfcase value="r">
        <cfset myResult="28">
        </cfcase>
        <cfcase value="s">
        <cfset myResult="29">
        </cfcase>
        <cfcase value="t">
        <cfset myResult="30">
        </cfcase>
        <cfcase value="u">
        <cfset myResult="31">
        </cfcase>
        <cfcase value="v">
        <cfset myResult="32">
        </cfcase>
        <cfcase value="w">
        <cfset myResult="33">
        </cfcase>
        <cfcase value="x">
        <cfset myResult="34">
        </cfcase>
        <cfcase value="y">
        <cfset myResult="35">
        </cfcase>
        <cfcase value="z">
        <cfset myResult="36">
        </cfcase>
        <cfcase value="*">
        <cfset myResult="37">
        </cfcase>
        <cfcase value="/">
        <cfset myResult="38">
        </cfcase>
        <cfcase value="_">
        <cfset myResult="39">
        </cfcase>
        <cfcase value=" ">
        <cfset myResult="40">
        </cfcase>
        <cfcase value=".">
        <cfset myResult="41">
        </cfcase>
        <cfdefaultcase>
        <cfset myResult="42">
        </cfdefaultcase>
        </cfswitch>
		<cfreturn myResult>
	</cffunction>
</cfcomponent>