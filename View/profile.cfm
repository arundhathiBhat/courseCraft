<cfif session.role == 'Admin'>
<cfinclude template = "./Admin/aside.cfm">
<main id="main" class="main">
    <div id="profile-content"></div>
</main>
<cfelse>
    <main id="mainProfile" class="mainProfile">
        <div id="profile-content"></div>
    </main>
</cfif>


