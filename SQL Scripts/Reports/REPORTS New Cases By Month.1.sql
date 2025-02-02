

print 'REPORTS New Cases By Month';
GO

set nocount on;
GO

-- delete from REPORTS where ID = '6215981D-4739-4885-834F-8923D671CD6E';
exec dbo.spREPORTS_InsertOnly '6215981D-4739-4885-834F-8923D671CD6E', 'New Cases By Month', 'Cases', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<DataSourceReference>SplendidCRM</DataSourceReference>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwCASES">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ASSIGNED_USER_ID">
						<Value>=Parameters!ASSIGNED_USER_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select ID
        , dbo.fnDateAdd(''day'', 1-dbo.fnDatePart(''day'', DATE_ENTERED), dbo.fnDateOnly(DATE_ENTERED)) as DATE_ENTERED
  from vwCASES
  left outer join vwTEAM_MEMBERSHIPS
               on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID
              and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID
 where 1 = 1
   and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)
</CommandText>
				<rd:DesignerState>
					<QueryDefinition xmlns="http://schemas.microsoft.com/ReportingServices/QueryDefinition/Relational">
						<SelectedColumns>
							<ColumnExpression ColumnOwner="vwCASES" ColumnName="DATE_ENTERED" GroupBy="True" />
						</SelectedColumns>
					</QueryDefinition>
				</rd:DesignerState>
			</Query>
			<Fields>
				<Field Name="DATE_ENTERED">
					<DataField>DATE_ENTERED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
			</Fields>
		</DataSet>
	</DataSets>
	<ReportSections>
		<ReportSection>
			<Body>
				<ReportItems>
					<Tablix Name="Tablix1">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>4.25in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>0.25in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="Textbox2">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Count</Value>
																	<Style>
																		<FontFamily>Tahoma</FontFamily>
																		<FontSize>11pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																		<Color>White</Color>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Center</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox2</rd:DefaultName>
													<Style>
														<Border>
															<Color>#7292cc</Color>
															<Style>Solid</Style>
														</Border>
														<BackgroundColor>#4c68a2</BackgroundColor>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
								<TablixRow>
									<Height>0.25in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="ID">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Count(Fields!ID.Value)</Value>
																	<Style>
																		<FontFamily>Tahoma</FontFamily>
																		<Color>#4d4d4d</Color>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Center</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ID</rd:DefaultName>
													<Style>
														<Border>
															<Color>#e5e5e5</Color>
															<Style>Solid</Style>
														</Border>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
							</TablixRows>
						</TablixBody>
						<TablixColumnHierarchy>
							<TablixMembers>
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<TablixHeader>
										<Size>4.25in</Size>
										<CellContents>
											<Textbox Name="Textbox3">
												<CanGrow>true</CanGrow>
												<KeepTogether>true</KeepTogether>
												<Paragraphs>
													<Paragraph>
														<TextRuns>
															<TextRun>
																<Value>Lead Source</Value>
																<Style>
																	<FontFamily>Tahoma</FontFamily>
																	<FontSize>11pt</FontSize>
																	<FontWeight>Bold</FontWeight>
																	<Color>White</Color>
																</Style>
															</TextRun>
														</TextRuns>
														<Style />
													</Paragraph>
												</Paragraphs>
												<rd:DefaultName>Textbox3</rd:DefaultName>
												<Style>
													<Border>
														<Color>#7292cc</Color>
														<Style>Solid</Style>
													</Border>
													<BackgroundColor>#4c68a2</BackgroundColor>
													<PaddingLeft>2pt</PaddingLeft>
													<PaddingRight>2pt</PaddingRight>
													<PaddingTop>2pt</PaddingTop>
													<PaddingBottom>2pt</PaddingBottom>
												</Style>
											</Textbox>
										</CellContents>
									</TablixHeader>
									<TablixMembers>
										<TablixMember />
									</TablixMembers>
								</TablixMember>
								<TablixMember>
									<Group Name="DATE_ENTERED">
										<GroupExpressions>
											<GroupExpression>=Fields!DATE_ENTERED.Value</GroupExpression>
										</GroupExpressions>
									</Group>
									<SortExpressions>
										<SortExpression>
											<Value>=Fields!DATE_ENTERED.Value</Value>
										</SortExpression>
									</SortExpressions>
									<TablixHeader>
										<Size>4.25in</Size>
										<CellContents>
											<Textbox Name="DATE_ENTERED">
												<CanGrow>true</CanGrow>
												<KeepTogether>true</KeepTogether>
												<Paragraphs>
													<Paragraph>
														<TextRuns>
															<TextRun>
																<Value>=Fields!DATE_ENTERED.Value</Value>
																<Style>
																	<FontFamily>Tahoma</FontFamily>
																	<FontWeight>Bold</FontWeight>
																	<Format>MMMM yyyy</Format>
																	<Color>#465678</Color>
																</Style>
															</TextRun>
														</TextRuns>
														<Style />
													</Paragraph>
												</Paragraphs>
												<rd:DefaultName>DATE_ENTERED</rd:DefaultName>
												<Style>
													<Border>
														<Color>#c6daf8</Color>
														<Style>Solid</Style>
													</Border>
													<BackgroundColor>#9eb6e4</BackgroundColor>
													<PaddingLeft>2pt</PaddingLeft>
													<PaddingRight>2pt</PaddingRight>
													<PaddingTop>2pt</PaddingTop>
													<PaddingBottom>2pt</PaddingBottom>
												</Style>
											</Textbox>
										</CellContents>
									</TablixHeader>
									<TablixMembers>
										<TablixMember />
									</TablixMembers>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwCASES</DataSetName>
						<Top>6.5in</Top>
						<Height>0.5in</Height>
						<Width>8.5in</Width>
						<Style>
							<Border>
								<Style>None</Style>
							</Border>
						</Style>
					</Tablix>
					<Chart Name="Chart1">
						<ChartCategoryHierarchy>
							<ChartMembers>
								<ChartMember>
									<Group Name="Chart1_CategoryGroup">
										<GroupExpressions>
											<GroupExpression>=Fields!DATE_ENTERED.Value</GroupExpression>
										</GroupExpressions>
									</Group>
									<SortExpressions>
										<SortExpression>
											<Value>=Fields!DATE_ENTERED.Value</Value>
										</SortExpression>
									</SortExpressions>
									<Label>=Fields!DATE_ENTERED.Value</Label>
								</ChartMember>
							</ChartMembers>
						</ChartCategoryHierarchy>
						<ChartSeriesHierarchy>
							<ChartMembers>
								<ChartMember>
									<Group Name="Chart1_SeriesGroup">
										<GroupExpressions>
											<GroupExpression>=Fields!DATE_ENTERED.Value</GroupExpression>
										</GroupExpressions>
									</Group>
									<SortExpressions>
										<SortExpression>
											<Value>=Fields!DATE_ENTERED.Value</Value>
										</SortExpression>
									</SortExpressions>
									<Label>=Fields!DATE_ENTERED.Value</Label>
								</ChartMember>
							</ChartMembers>
						</ChartSeriesHierarchy>
						<ChartData>
							<ChartSeriesCollection>
								<ChartSeries Name="ID">
									<ChartDataPoints>
										<ChartDataPoint>
											<ChartDataPointValues>
												<Y>=Count(Fields!ID.Value)</Y>
											</ChartDataPointValues>
											<ChartDataLabel>
												<Style />
												<UseValueAsLabel>true</UseValueAsLabel>
											</ChartDataLabel>
											<Style />
											<ChartMarker>
												<Style />
											</ChartMarker>
											<DataElementOutput>Output</DataElementOutput>
										</ChartDataPoint>
									</ChartDataPoints>
									<Subtype>Stacked</Subtype>
									<Style />
									<ChartEmptyPoints>
										<Style />
										<ChartMarker>
											<Style />
										</ChartMarker>
										<ChartDataLabel>
											<Style />
										</ChartDataLabel>
									</ChartEmptyPoints>
									<ValueAxisName>Primary</ValueAxisName>
									<CategoryAxisName>Primary</CategoryAxisName>
									<ChartSmartLabel>
										<CalloutLineColor>Black</CalloutLineColor>
										<MinMovingDistance>0pt</MinMovingDistance>
									</ChartSmartLabel>
								</ChartSeries>
							</ChartSeriesCollection>
						</ChartData>
						<ChartAreas>
							<ChartArea Name="Default">
								<ChartCategoryAxes>
									<ChartAxis Name="Primary">
										<Style>
											<Border>
												<Color>LightGrey</Color>
											</Border>
											<FontFamily>Tahoma</FontFamily>
											<FontSize>8pt</FontSize>
											<Format>MMMM yyyy</Format>
										</Style>
										<ChartAxisTitle>
											<Caption />
											<Style>
												<FontFamily>Tahoma</FontFamily>
												<FontSize>8pt</FontSize>
											</Style>
										</ChartAxisTitle>
										<ChartMajorGridLines>
											<Enabled>False</Enabled>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
												</Border>
											</Style>
										</ChartMajorGridLines>
										<ChartMinorGridLines>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
													<Style>Dotted</Style>
												</Border>
											</Style>
										</ChartMinorGridLines>
										<ChartMajorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
										</ChartMajorTickMarks>
										<ChartMinorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
											<Length>0.5</Length>
										</ChartMinorTickMarks>
										<CrossAt>NaN</CrossAt>
										<Minimum>NaN</Minimum>
										<Maximum>NaN</Maximum>
										<AllowLabelRotation>Rotate45</AllowLabelRotation>
										<ChartAxisScaleBreak>
											<Style />
										</ChartAxisScaleBreak>
									</ChartAxis>
									<ChartAxis Name="Secondary">
										<Style>
											<Border>
												<Color>LightGrey</Color>
											</Border>
											<FontFamily>Tahoma</FontFamily>
											<FontSize>8pt</FontSize>
										</Style>
										<ChartAxisTitle>
											<Caption>Axis Title</Caption>
											<Style>
												<FontFamily>Tahoma</FontFamily>
												<FontSize>8pt</FontSize>
											</Style>
										</ChartAxisTitle>
										<ChartMajorGridLines>
											<Enabled>False</Enabled>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
												</Border>
											</Style>
										</ChartMajorGridLines>
										<ChartMinorGridLines>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
													<Style>Dotted</Style>
												</Border>
											</Style>
										</ChartMinorGridLines>
										<ChartMajorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
										</ChartMajorTickMarks>
										<ChartMinorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
											<Length>0.5</Length>
										</ChartMinorTickMarks>
										<CrossAt>NaN</CrossAt>
										<Location>Opposite</Location>
										<Minimum>NaN</Minimum>
										<Maximum>NaN</Maximum>
										<ChartAxisScaleBreak>
											<Style />
										</ChartAxisScaleBreak>
									</ChartAxis>
								</ChartCategoryAxes>
								<ChartValueAxes>
									<ChartAxis Name="Primary">
										<Style>
											<Border>
												<Color>LightGrey</Color>
											</Border>
											<FontFamily>Tahoma</FontFamily>
											<FontSize>8pt</FontSize>
										</Style>
										<ChartAxisTitle>
											<Caption />
											<Style>
												<FontFamily>Tahoma</FontFamily>
												<FontSize>8pt</FontSize>
											</Style>
										</ChartAxisTitle>
										<ChartMajorGridLines>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
												</Border>
											</Style>
										</ChartMajorGridLines>
										<ChartMinorGridLines>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
													<Style>Dotted</Style>
												</Border>
											</Style>
										</ChartMinorGridLines>
										<ChartMajorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
										</ChartMajorTickMarks>
										<ChartMinorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
											<Length>0.5</Length>
										</ChartMinorTickMarks>
										<CrossAt>NaN</CrossAt>
										<Minimum>NaN</Minimum>
										<Maximum>NaN</Maximum>
										<ChartAxisScaleBreak>
											<Style />
										</ChartAxisScaleBreak>
									</ChartAxis>
									<ChartAxis Name="Secondary">
										<Style>
											<Border>
												<Color>LightGrey</Color>
											</Border>
											<FontFamily>Tahoma</FontFamily>
											<FontSize>8pt</FontSize>
										</Style>
										<ChartAxisTitle>
											<Caption>Axis Title</Caption>
											<Style>
												<FontFamily>Tahoma</FontFamily>
												<FontSize>8pt</FontSize>
											</Style>
										</ChartAxisTitle>
										<ChartMajorGridLines>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
												</Border>
											</Style>
										</ChartMajorGridLines>
										<ChartMinorGridLines>
											<Style>
												<Border>
													<Color>Gainsboro</Color>
													<Style>Dotted</Style>
												</Border>
											</Style>
										</ChartMinorGridLines>
										<ChartMajorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
										</ChartMajorTickMarks>
										<ChartMinorTickMarks>
											<Style>
												<Border>
													<Color>LightGrey</Color>
												</Border>
											</Style>
											<Length>0.5</Length>
										</ChartMinorTickMarks>
										<CrossAt>NaN</CrossAt>
										<Location>Opposite</Location>
										<Minimum>NaN</Minimum>
										<Maximum>NaN</Maximum>
										<ChartAxisScaleBreak>
											<Style />
										</ChartAxisScaleBreak>
									</ChartAxis>
								</ChartValueAxes>
								<Style>
									<BackgroundColor>#e6eefc</BackgroundColor>
									<BackgroundGradientType>None</BackgroundGradientType>
								</Style>
							</ChartArea>
						</ChartAreas>
						<ChartLegends>
							<ChartLegend Name="Legend1">
								<Style>
									<BackgroundGradientType>None</BackgroundGradientType>
									<FontSize>8pt</FontSize>
								</Style>
								<Position>BottomLeft</Position>
								<DockOutsideChartArea>true</DockOutsideChartArea>
								<ChartLegendTitle>
									<Caption />
									<Style>
										<FontSize>8pt</FontSize>
										<FontWeight>Bold</FontWeight>
										<TextAlign>Center</TextAlign>
									</Style>
								</ChartLegendTitle>
								<HeaderSeparatorColor>Black</HeaderSeparatorColor>
								<ColumnSeparatorColor>Black</ColumnSeparatorColor>
							</ChartLegend>
						</ChartLegends>
						<ChartTitles>
							<ChartTitle Name="Default">
								<Caption>New Cases By Month</Caption>
								<Style>
									<BackgroundGradientType>None</BackgroundGradientType>
									<FontFamily>Tahoma</FontFamily>
									<FontSize>14pt</FontSize>
									<FontWeight>Bold</FontWeight>
									<TextAlign>General</TextAlign>
									<VerticalAlign>Top</VerticalAlign>
								</Style>
							</ChartTitle>
						</ChartTitles>
						<Palette>Custom</Palette>
						<ChartCustomPaletteColors>
							<ChartCustomPaletteColor>#4c68a2</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#b5dddf</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#7292cc</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#89bcc5</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#c4d5f3</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#c6c595</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#87acf3</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#7b9291</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#a8c4ec</ChartCustomPaletteColor>
							<ChartCustomPaletteColor>#a49ed4</ChartCustomPaletteColor>
						</ChartCustomPaletteColors>
						<ChartBorderSkin>
							<ChartBorderSkinType>Emboss</ChartBorderSkinType>
							<Style>
								<BackgroundColor>Gray</BackgroundColor>
								<BackgroundGradientType>None</BackgroundGradientType>
								<Color>White</Color>
							</Style>
						</ChartBorderSkin>
						<ChartNoDataMessage Name="NoDataMessage">
							<Caption>No Data Available</Caption>
							<Style>
								<BackgroundGradientType>None</BackgroundGradientType>
								<FontFamily>Tahoma</FontFamily>
								<FontSize>8pt</FontSize>
								<TextAlign>General</TextAlign>
								<VerticalAlign>Top</VerticalAlign>
							</Style>
						</ChartNoDataMessage>
						<DataSetName>vwCASES</DataSetName>
						<Height>6.5in</Height>
						<Width>8.5in</Width>
						<ZIndex>1</ZIndex>
						<Style>
							<Border>
								<Color>#7292cc</Color>
								<Style>Solid</Style>
								<Width>2pt</Width>
							</Border>
							<BackgroundColor>#c6daf8</BackgroundColor>
							<BackgroundGradientType>TopBottom</BackgroundGradientType>
							<BackgroundGradientEndColor>#e6eefc</BackgroundGradientEndColor>
						</Style>
					</Chart>
				</ReportItems>
				<Height>7in</Height>
				<Style>
					<Border>
						<Style>None</Style>
					</Border>
				</Style>
			</Body>
			<Width>8.5in</Width>
			<Page>
				<PageFooter>
					<Height>0.01042in</Height>
					<PrintOnFirstPage>true</PrintOnFirstPage>
					<PrintOnLastPage>true</PrintOnLastPage>
					<Style>
						<Border>
							<Style>None</Style>
						</Border>
					</Style>
				</PageFooter>
				<LeftMargin>1in</LeftMargin>
				<RightMargin>1in</RightMargin>
				<TopMargin>1in</TopMargin>
				<BottomMargin>1in</BottomMargin>
				<Style />
			</Page>
		</ReportSection>
	</ReportSections>
	<ReportParameters>
		<ReportParameter Name="ASSIGNED_USER_ID">
			<DataType>String</DataType>
			<Nullable>true</Nullable>
			<Prompt>Assigned To:</Prompt>
		</ReportParameter>
	</ReportParameters>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>6215981D-4739-4885-834F-8923D671CD6E</rd:ReportID>
</Report>', '17BB7135-2B95-42DC-85DE-842CAFF927A0';
GO


set nocount off;
GO

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spREPORTS_New_Cases_By_Month()
/

call dbo.spSqlDropProcedure('spREPORTS_New_Cases_By_Month')
/

-- #endif IBM_DB2 */

