<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/portal_settings/init.jsp" %>

<%
String[] configurationSections = PropsValues.COMPANY_SETTINGS_FORM_CONFIGURATION;
String[] identificationSections = PropsValues.COMPANY_SETTINGS_FORM_IDENTIFICATION;
String[] miscellaneousSections = PropsValues.COMPANY_SETTINGS_FORM_MISCELLANEOUS;
String[] socialSections = PropsValues.COMPANY_SETTINGS_FORM_SOCIAL;

String[][] categorySections = {configurationSections, identificationSections, miscellaneousSections, socialSections};

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("struts_action", "/portal_settings/view");

request.setAttribute("addresses.className", Account.class.getName());
request.setAttribute("emailAddresses.className", Account.class.getName());
request.setAttribute("phones.className", Account.class.getName());
request.setAttribute("websites.className", Account.class.getName());

request.setAttribute("addresses.classPK", company.getAccountId());
request.setAttribute("emailAddresses.classPK", company.getAccountId());
request.setAttribute("phones.classPK", company.getAccountId());
request.setAttribute("websites.classPK", company.getAccountId());
%>

<portlet:actionURL var="editCompanyURL">
	<portlet:param name="struts_action" value="/portal_settings/edit_company" />
</portlet:actionURL>

<aui:form action="<%= editCompanyURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "saveCompany();" %>'>
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="redirect" type="hidden" />

	<liferay-util:buffer var="htmlTop">
		<div class="company-info">
			<p class="float-container">
				<img alt="<liferay-ui:message escapeAttribute="<%= true %>" key="logo" />" class="company-logo" src="<%= themeDisplay.getPathImage() %>/company_logo?img_id=<%= company.getLogoId() %>&t=<%= WebServerServletTokenUtil.getToken(company.getLogoId()) %>" /><br />

				<span class="company-name"><%= HtmlUtil.escape(company.getName()) %></span>
			</p>
		</div>
	</liferay-util:buffer>

	<liferay-ui:form-navigator
		categoryNames="<%= _CATEGORY_NAMES %>"
		categorySections="<%= categorySections %>"
		htmlTop="<%= htmlTop %>"
		jspPath="/html/portlet/portal_settings/"
		showButtons="<%= RoleLocalServiceUtil.hasUserRole(user.getUserId(), company.getCompanyId(), RoleConstants.ADMINISTRATOR, true) %>"
	/>
</aui:form>

<aui:script>
	function <portlet:namespace />saveCompany() {
		var form = AUI.$(document.<portlet:namespace />fm);

		form.fm('<%= Constants.CMD %>').val('<%= Constants.UPDATE %>');

		<portlet:namespace />saveLdap();
		<portlet:namespace />saveLocales();

		submitForm(form);
	}

	function <portlet:namespace />saveLdap() {
		var $ = AUI.$;

		var ldapServerIds = $('.ldap-servers .table-data tr').map(
			function(index, item) {
				return $(item).data('ldapserverid');
			}
		).get();

		$(document.<portlet:namespace />fm).fm('settings--ldap.server.ids--').val(ldapServerIds.join(','));
	}

	Liferay.provide(
		window,
		'<portlet:namespace />saveLocales',
		function() {
			var locales = document.<portlet:namespace />fm.<portlet:namespace /><%= PropsKeys.LOCALES %>;

			if (locales) {
				locales.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />currentLanguageIds);
			}
		},
		['liferay-util-list-fields']
	);
</aui:script>

<%!
private static final String[] _CATEGORY_NAMES = {"configuration", "identification", "miscellaneous", "social"};
%>