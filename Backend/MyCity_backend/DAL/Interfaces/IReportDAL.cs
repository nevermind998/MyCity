using backendPoSlojevima.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace backendPoSlojevima.DAL.Interfaces
{
    public interface IReportDAL
    {
        List<Report> getAllReport();
        int saveReport(Report report);
        void deleteReprot(List<Report> report);
        List<RazlogPrijave> getRazlogePrijave();
        List<KorisnikIRazlogPrijave> getKorisnikeIRazlogPrijave(long idObjave);

    }
}
