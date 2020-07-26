using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IReportKomentaraDAL
    {
        List<ReportKomentari> getAllReport();
        public void saveReport(ReportKomentari data);
        public void deleteReportoveKomentara(List<ReportKomentari> reportovi);
        public int getReportKomentaraByIdKorisnika(long idKorisnika, long idKomentara);


    }
}
