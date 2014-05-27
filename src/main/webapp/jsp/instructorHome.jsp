<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="teammates.common.util.TimeHelper"%>
<%@ page import="teammates.common.util.Const" %>
<%@ page import="teammates.common.datatransfer.CourseSummaryBundle"%>
<%@ page import="teammates.common.datatransfer.EvaluationAttributes"%>
<%@ page import="teammates.common.datatransfer.FeedbackSessionAttributes"%>
<%@ page import="teammates.ui.controller.PageData"%>
<%@ page import="teammates.ui.controller.InstructorHomePageData"%>
<%
    InstructorHomePageData data = (InstructorHomePageData)request.getAttribute("data");
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="shortcut icon" href="/favicon.png" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TEAMMATES - Instructor</title>
    <link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css" type="text/css"/>
    <link rel="stylesheet" href="/bootstrap/css/bootstrap-theme.min.css" type="text/css"/>
    <link rel="stylesheet" href="/stylesheets/teammatesCommon.css" type="text/css"/>
    
    <script type="text/javascript" src="/js/googleAnalytics.js"></script>
    <script type="text/javascript" src="/js/jquery-minified.js"></script>
    <script type="text/javascript" src="/js/date.js"></script>
    <script type="text/javascript" src="/js/CalendarPopup.js"></script>
    <script type="text/javascript" src="/js/AnchorPosition.js"></script>
    <script type="text/javascript" src="/js/common.js"></script>
    <script type="text/javascript"  src="/bootstrap/js/bootstrap.min.js"></script>
    
    <script type="text/javascript" src="/js/instructor.js"></script>
    <script type="text/javascript" src="/js/instructorHome.js"></script>
    <script type="text/javascript" src="/js/ajaxResponseRate.js"></script>
    <jsp:include page="../enableJS.jsp"></jsp:include>
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>
    <jsp:include page="<%=Const.ViewURIs.INSTRUCTOR_HEADER%>" />

    <div id="frameBodyWrapper" class="container theme-showcase">
        <div id="topOfPage"></div>
        <div class="inner-container">
            <div class="row">
                <div class="col-md-5">
                    <h1>Instructor Home</h1>
                </div>
                <div class="col-md-5 instructor-header-bar">
                    <form method="post" action="<%=Const.ActionURIs.INSTRUCTOR_STUDENT_LIST_PAGE%>" name="search_form">
                        <div class="input-group">
                            <input type="text" name=<%=Const.ParamsNames.SEARCH_KEY %>
                                title="<%=Const.Tooltips.SEARCH_STUDENT%>"
                                class="form-control" placeholder="Student Name">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="submit" value="Search">Search</button>
                            </span>
                        </div>
                        <input type="hidden" name="<%=Const.ParamsNames.USER_ID%>" value="<%=data.account.googleId%>">
                    </form>
                </div>
                <div class="col-md-2 instructor-header-bar">
                    <a class="btn btn-primary btn-md" href="<%=data.getInstructorCourseLink() %>" id="addNewCourse">Add New Course </a>
                </div>
            </div>
        </div>
        <br>
        <jsp:include page="<%=Const.ViewURIs.STATUS_MESSAGE%>" />
        
        <div class="row">
            <div class="col-md-5 pull-right">
                <div class="row">
                    <div class="col-md-3 btn-group">
                        <h5 class="pull-right"><strong> Sort By: </strong></h5>
                    </div>
                    <div class="col-md-9">
                        <div class="btn-group pull-right" data-toggle="buttons">
                            <label class="btn btn-default <%= data.sortCriteria.equals(Const.SORT_BY_COURSE_ID) ? "active" : "" %>" name="sortby" data="id">
                                <input type="radio">
                                Course ID
                            </label>
                            <label class="btn btn-default <%= data.sortCriteria.equals(Const.SORT_BY_COURSE_NAME) ? "active" : "" %>" name="sortby" data="name">
                                <input type="radio" name="sortby" value="name" >
                                Course Name
                            </label>
                            <label class="btn btn-default <%= data.sortCriteria.equals(Const.SORT_BY_COURSE_CREATION_DATE) ? "active" : "" %>" name="sortby" data="createdAt">
                                <input type="radio">
                                Creation Date
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br>
    <%
        int courseIdx = -1;
        int sessionIdx = -1;
        for (CourseSummaryBundle courseDetails : data.courses) {
            // TODO: optimize in future
            // We may be able to reduce database reads here because we don't need to retrieve certain data for archived courses
            if (!courseDetails.course.isArchived) {
                courseIdx++;
    %>
                <div class="panel panel-primary" id="course<%=courseIdx%>">
                    <div class="panel-heading">
                        <strong class="color_white">
                            [<%=courseDetails.course.id%>] :
                            <%=PageData.sanitizeForHtml(courseDetails.course.name)%>
                        </strong>
                        <span class="pull-right">
                             <a class="btn btn-primary btn-xs btn-tm-actions"
                                href="<%=data.getInstructorCourseEnrollLink(courseDetails.course.id)%>"
                                title="<%=Const.Tooltips.COURSE_ENROLL%>" data-toggle="tooltip" data-placement="top"> Enroll</a>
                                 
                             <a class="btn btn-primary btn-xs btn-tm-actions"
                                href="<%=data.getInstructorCourseDetailsLink(courseDetails.course.id)%>"
                                title="<%=Const.Tooltips.COURSE_DETAILS%>" data-toggle="tooltip" data-placement="top"> View</a> 
                                
                             <a class="btn btn-primary btn-xs btn-tm-actions"
                                href="<%=data.getInstructorCourseEditLink(courseDetails.course.id)%>"
                                title="<%=Const.Tooltips.COURSE_EDIT%>" data-toggle="tooltip" data-placement="top"> Edit</a>
                                
                             <a class="btn btn-primary btn-xs btn-tm-actions"
                                href="<%=data.getInstructorEvaluationLinkForCourse(courseDetails.course.id)%>"
                                title="<%=Const.Tooltips.COURSE_ADD_EVALUATION%>" data-toggle="tooltip" data-placement="top"> Add Session</a>
                             
                             <a class="btn btn-primary btn-xs btn-tm-actions"
                                href="<%=data.getInstructorCourseArchiveLink(courseDetails.course.id, true, true)%>"
                                title="<%=Const.Tooltips.COURSE_ARCHIVE%>" data-toggle="tooltip" data-placement="top"
                                onclick="return toggleArchiveCourseConfirmation('<%=courseDetails.course.id%>')">Archive</a>
                                
                             <a class="btn btn-primary btn-xs btn-tm-actions"
                                href="<%=data.getInstructorCourseDeleteLink(courseDetails.course.id,true)%>"
                                title="<%=Const.Tooltips.COURSE_DELETE%>" data-toggle="tooltip" data-placement="top"
                                onclick="return toggleDeleteCourseConfirmation('<%=courseDetails.course.id%>')"> Delete</a>
                        </span>
                    </div>
                    <%
                        if (courseDetails.evaluations.size() > 0||
                            courseDetails.feedbackSessions.size() > 0) {
                    %>
                            <table class="table-responsive table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th id="button_sortname" onclick="toggleSort(this,1);"
                                            class="button-sort-none">
                                            Session Name<span class="sort-icon unsorted"></span></th>
                                        <th>Status</th>
                                        <th>
                                            <span title="<%=Const.Tooltips.EVALUATION_RESPONSE_RATE%>" data-toggle="tooltip" data-placement="top">Response Rate</span>
                                        </th>
                                        <th class="no-print">Action(s)</th>
                                    </tr>
                                </thead>
                        <%
                            for (EvaluationAttributes edd: courseDetails.evaluations){
                                sessionIdx++;
                        %>
                                <tr id="session<%=sessionIdx%>">
                                    <td><%=PageData.sanitizeForHtml(edd.name)%></td>
                                    <td>
                                        <span title="<%=PageData.getInstructorHoverMessageForEval(edd)%>" data-toggle="tooltip" data-placement="top">
                                            <%=PageData.getInstructorStatusForEval(edd)%>
                                        </span>
                                    </td>
                                    <td class="session-response<% if(!TimeHelper.isOlderThanAYear(edd.endTime)) { out.print(" recent");} %>">
                                        <a oncontextmenu="return false;" href="<%=data.getEvaluationStatsLink(edd.courseId, edd.name)%>">Show</a>
                                    </td>
                                    <td class="no-print"><%=data.getInstructorEvaluationActions(edd, true)%>
                                    </td>
                                </tr>
                        <%
                            }
                            for(FeedbackSessionAttributes fdb: courseDetails.feedbackSessions) {
                                sessionIdx++;
                        %>
                                <tr id="session<%=sessionIdx%>">
                                    <td><%=PageData
                                            .sanitizeForHtml(fdb.feedbackSessionName)%></td>
                                    <td>
                                        <span title="<%=PageData.getInstructorHoverMessageForFeedbackSession(fdb)%>" data-toggle="tooltip" data-placement="top">
                                            <%=PageData.getInstructorStatusForFeedbackSession(fdb)%>
                                        </span>
                                    </td>
                                    <td class="session-response<% if(!TimeHelper.isOlderThanAYear(fdb.createdTime)) { out.print(" recent");} %>">
                                        <a oncontextmenu="return false;" href="<%=data.getFeedbackSessionStatsLink(fdb.courseId, fdb.feedbackSessionName)%>">Show</a>
                                    </td>
                                    <td class="no-print"><%=data.getInstructorFeedbackSessionActions(
                                            fdb, false)%></td>
                                </tr>
                        <%
                            }
                        %>
                            </table>
                    <%
                        }
                    %>
                </div>
                <br>
    <%
                out.flush();
            }
        }
    %>
    </div>    
    <br>
    <br>
    <br>
    <jsp:include page="<%=Const.ViewURIs.FOOTER%>" />
</body>
</html>